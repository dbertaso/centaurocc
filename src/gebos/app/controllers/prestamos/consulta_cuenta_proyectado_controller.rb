class Prestamos::ConsultaCuentaProyectadoController < FormTabTabsController

  include RjReport
  layout 'form'
  
  def index
    fecha = Time.now + 1.day
    if fecha.day >= 10
      fecha1 = fecha.day.to_s << '/'
    else
      fecha1 = '0' << fecha.day.to_s << '/'
    end
    if fecha.month >= 10
      fecha1 = fecha1 << fecha.month.to_s << '/' << fecha.year.to_s
    else
      fecha1 = fecha1 << '0' << fecha.month.to_s << '/' << fecha.year.to_s
    end
    @fecha = fecha1
    @prestamo = Prestamo.find(params[:id])
  end
  
  def buscar
   hoy = (Time.now.year.to_s + '-' + Time.now.month.to_s + '-' + Time.now.day.to_s).to_date
   fecha = params[:fecha].split('/')
   fecha = (fecha[2] + '-' + fecha[1] + '-' + fecha[0]).to_date
  # unless fecha > hoy
  #   render :update do |page|
  #      page.alert "La fecha para realizar el calculo debe ser mayor a la fecha de hoy"
  #    end
  #    return
  # end
  
   factura = Factura.find(:first, :conditions=>["tipo = 'P' and prestamo_id = ?", params[:id]], :order=>'id desc')
    
    unless factura.nil?
      unless fecha > factura.fecha_realizacion
        fecha = factura.fecha_realizacion.to_s.split('-')
        render :update do |page|
         page.alert 'La fecha para el calculo debe ser mayor a la fecha ' << fecha[2].to_s << '/' << fecha[1].to_s << '/'<< fecha[0].to_s << ' ya que existen eventos financieros asociados.'
         page.<< "varEnviado=false" 
        end
       return
     end
   end
   plan_pago = PlanPago.find(:first, :conditions=>['prestamo_id = ?', params[:id]])
   plan_pago_cuota = PlanPagoCuota.find_by_sql("select * from plan_pago_cuota where plan_pago_id = " << plan_pago.id.to_s << " order by fecha desc limit 1")
   
   unless plan_pago_cuota[0].fecha >= fecha
     unless plan_pago_cuota[0].fecha < hoy
       render :update do |page|
          page.alert "La fecha para realizar el calculo debe ser menor a la fecha de la ultima cuota del prestamo"
        end
        return
     end
   end
   
   fecha = params[:fecha].split('/')
   
   if plan_pago_cuota[0].fecha > hoy
     @monto_mora = 0
     @dias_mora = 0
     retorno = ViewContratoBasico.find_by_sql("select calcula_cuenta_proyectado(" + params[:id].to_s + ",'" + (fecha[2] + '-' + fecha[1] + '-' + fecha[0]) + "');")
   else
     plan_pago_cuota = PlanPagoCuota.find(plan_pago_cuota[0].id)
     @monto_mora = (plan_pago_cuota.total_monto_mora_proyectado((Time.now.day.to_s + '/' + Time.now.month.to_s + '/' + Time.now.year.to_s),(fecha[2] + '-' + fecha[1] + '-' + fecha[0]))) 
     @dias_mora = plan_pago_cuota.total_dias_mora_proyectado((Time.now.day.to_s + '/' + Time.now.month.to_s + '/' + Time.now.year.to_s),(fecha[2] + '-' + fecha[1] + '-' + fecha[0]))
   end

   @fecha_proceso = (fecha[0] + '/' + fecha[1] + '/' + fecha[2])
   @prestamo_id = params[:id]
   render :update do |page|
      page.replace_html 'botones', render(:partial=>'botones')
      page.show 'botones'
    end
  end
  
  def atras
     plan_pago = PlanPago.find(:first, :conditions=>['prestamo_id = ?', params[:id]])
     plan_pago_cuota = PlanPagoCuota.find_by_sql("select * from plan_pago_cuota where plan_pago_id = " << plan_pago.id.to_s << " order by fecha desc limit 1")
     hoy = (Time.now.year.to_s + '-' + Time.now.month.to_s + '-' + Time.now.day.to_s).to_date
     unless plan_pago_cuota[0].fecha < hoy
       fecha = Time.now - 1.day
       fecha1 = fecha.year.to_s << '/'
       if fecha.month >= 10
        fecha1 = fecha1 << fecha.month.to_s << '/'
       else
          fecha1 = fecha1 << '0' << fecha.month.to_s << '/' 
       end
      if fecha.day >= 10
        fecha1 = fecha1 << fecha.day.to_s
      else
        fecha1 = fecha1 << '0' << fecha.day.to_s
      end
      retorno = ViewContratoBasico.find_by_sql("select calcula_cuenta_proyectado(" + params[:id].to_s + ",'" + fecha1 + "')")
    end
    flash[:notice] = "Se ha retornado los datos al estado original"
    render :update do |page|
      page.redirect_to :action=>'index', :id=>params[:id], :popup=>params[:popup]
    end 
  end
  
  def imprimir
  
    @prestamo = Prestamo.find(params[:prestamo_id])
    @reporte = params[:reporte]
    
    parameters = {:p_prestamo=> [@prestamo.numero, "Long"], :p_fecha_proceso => [params[:fecha], "date"], :p_mora_dif => [params[:monto_mora], "Double"], :p_dias_dif => [params[:dias_mora], "integer"]  }
    nombre_reporte = "estado_cuenta_proyectado"
    nombre_carpeta = 'prestamos'
    send_doc(nombre_reporte, parameters, nombre_carpeta,  "estado_cuenta " + :prestamo_id.to_s, "pdf" )
    
  end 
  

  protected  
  def common
    super
    @form_title = 'Estado de Cuenta Proyectado'
    @form_title_record = 'Plan Pago' 
    @form_title_records = 'Plan Pago'
    @form_entity = 'plan_pago'
    @form_identity_field = 'prestamo.numero'
  end

end

