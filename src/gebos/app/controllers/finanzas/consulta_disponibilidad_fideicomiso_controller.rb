# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::ConsultaDisponibilidadFideicomisoController
# descripción: Migración a Rails 3
#

class Finanzas::ConsultaDisponibilidadFideicomisoController < FormClassicController

#  layout 'form_basic'
#  # gem 'prawn-format', '=0.1.1'
#  require 'prawn'
#  require 'prawn/layout'
#  require 'prawn/format'
#  require 'prawn/measurement_extensions'

skip_before_filter :set_charset, :only=>[:entidad_form_change,:entidad_change,:list]
  
	def index    
    fill_tipo_mov_manual
    fill_entidad_financiera
    fideicomiso_fill(0)
	end

  def list
   filtro_fecha = true
   filtro_fecha_s = "fideicomiso_movimientos.id > 0"
   condicion_fideicomiso=''
    @fecha_inicio = params[:dfecha].to_s
    @fecha_fin = params[:hfecha].to_s

    unless params[:nro_fideicomiso][0]==''
      @fideicomiso = Fideicomiso.find_by_id(params[:nro_fideicomiso][0])
      @programa_fideicomiso = Programa.find_by_id(@fideicomiso.programa_id)
      condicion_fideicomiso=' and fideicomiso_id = ' << params[:nro_fideicomiso][0].to_s
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.fideicomiso')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{Fideicomiso.find(params[:nro_fideicomiso][0]).numero_fideicomiso}'"
    end

    if params[:dfecha].to_s =="" and params[:hfecha].to_s == ""
      filtro_fecha_s="fideicomiso_movimientos.id > 0"
    elsif params[:dfecha].to_s =="" and params[:hfecha].to_s != ""      
      @fecha_fin =format_fecha_conversion(params[:hfecha])
      hf = @fecha_fin
      filtro_fecha_s << " and fecha_movimiento <= '" << hf.to_s << "'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.AutorizacionAprobacion.Etiquetas.fecha_hasta')} '#{params[:hfecha].to_s}'"
    elsif params[:dfecha].to_s !="" and params[:hfecha].to_s == ""
      @fecha_inicio=format_fecha_conversion(params[:dfecha])      
      df = @fecha_inicio
      filtro_fecha_s << " and fecha_movimiento >= '" << df.to_s << "'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.AutorizacionAprobacion.Etiquetas.fecha_desde')} '#{params[:dfecha].to_s}'"
    else
      @fecha_inicio=format_fecha_conversion(params[:dfecha])
      @fecha_fin =format_fecha_conversion(params[:hfecha])
      df = @fecha_inicio
      hf = @fecha_fin
      filtro_fecha_s << " and fecha_movimiento between '" << df.to_s << "' and '" << hf.to_s << "'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.AutorizacionAprobacion.Etiquetas.fecha_desde')} '#{params[:dfecha].to_s}' #{I18n.t('Sistema.Body.Vistas.AutorizacionAprobacion.Etiquetas.fecha_hasta')} '#{params[:hfecha].to_s}'"
    end
 
    
    


    @list = FideicomisoMovimientos.search(filtro_fecha_s << condicion_fideicomiso, params[:page], params['sort'],"fideicomiso_movimientos.*,usuario.nombre_usuario as usuario, tipo_movimiento_fideicomiso.modo_nota, case when tipo_movimiento_fideicomiso.tipo_nota = -1 then 'NCR' else 'NDB' end || '-' || tipo_movimiento_fideicomiso.motivo as tipo_movimiento",'INNER JOIN usuario ON fideicomiso_movimientos.usuario_id = usuario.id INNER JOIN tipo_movimiento_fideicomiso ON tipo_movimiento_fideicomiso.id = fideicomiso_movimientos.tipo_movimiento_id')    
    @total=@list.count


    #@pages, @list = paginate(:fideicomiso_movimientos, :class_name => 'FideicomisoMovimientos',
    #  :per_page => @records_by_page,
    #  :conditions => 'fideicomiso_id = ' << params[:nro_fideicomiso].to_s << filtro_fecha_s,
    #  :select=>"fideicomiso_movimientos.*,usuario.nombre_usuario as usuario, tipo_movimiento_fideicomiso.modo_nota, case when tipo_movimiento_fideicomiso.tipo_nota = -1 then 'NCR' else 'NDB' end || '-' || tipo_movimiento_fideicomiso.motivo as tipo_movimiento",
    #  :joins=>'INNER JOIN usuario ON fideicomiso_movimientos.usuario_id = usuario.id INNER JOIN tipo_movimiento_fideicomiso ON tipo_movimiento_fideicomiso.id = fideicomiso_movimientos.tipo_movimiento_id',
    #  :order_by => @params['sort'])
    #@total=@pages.item_count

    form_list

  end  
  
  
  def entidad_form_change
    if params[:entidad_financiera_id] == ''
      fideicomiso_fill(0)
    else
      fideicomiso_fill(params[:entidad_financiera_id])
    end
    render :update do |page|
      page.replace_html 'nro-fideicomiso-select', :partial => 'nro_fideicomiso_form_select'
      page.show 'nro-fideicomiso-select'
    end
  end
  
  def entidad_change
    if params[:entidad_financiera_id] == ''
      fideicomiso_fill(0)
    else
      fideicomiso_fill(params[:entidad_financiera_id])
    end
    render :update do |page|
      page.replace_html 'nro-fideicomiso-select', :partial => 'nro_fideicomiso_select'
      page.show 'nro-fideicomiso-select'
    end
  end
  
  def view
    
  end
  
  def eliminar_mov
      @fid = Fideicomiso.find_by_id(params[:nro_fideicomiso])
      @movfid = FideicomisoMovimientos.find_by_id(params[:nro_mov])
      @tf=TipoMovimientoFideicomiso.find_by_id(@movfid.tipo_movimiento_id)
      @formula = '"(' << (@tf.sub_cuenta_banco ? (@tf.afecta_banco*-1) : '0').to_s << ' * B) + (' << (@tf.sub_cuenta_insumos ? (@tf.afecta_insumos*-1) : '0').to_s << ' * I) + (' << (@tf.sub_cuenta_gastos ? (@tf.afecta_gastos*-1) : '0').to_s << ' * G) + (' << (@tf.sub_cuenta_sras ? (@tf.afecta_sras*-1) : '0').to_s << ' * S)"'
      banco=@movfid.monto_banco.nil? ? '0' : @movfid.monto_banco
      insumos=@movfid.monto_insumos.nil? ? '0' : @movfid.monto_insumos
      gastos=@movfid.monto_gastos.nil? ? '0' : @movfid.monto_gastos
      sras=@movfid.monto_sras.nil? ? '0' : @movfid.monto_sras
      @formula=formulaf
      formulaf.gsub!("B",banco)
      formulaf.gsub!("I",insumos)
      formulaf.gsub!("G",gastos)
      formulaf.gsub!("S",sras)
#      total = eval(formulaf)  
#      mcomision=@movfid.comision
#        var monto_oper=parseFloat(document.getElementById('movimiento_fideicomiso_monto_operacion').value);
#        var monto_antes=parseFloat(document.getElementById('movimiento_fideicomiso_saldo_disponible_antes').value);
#        var tipo_mov = document.getElementById('movimiento_fideicomiso_tipo_movimiento_id');
#       if (afecta_disponible==1) 
#        {
#              if(tipo_mov.options[tipo_mov.selectedIndex].text.substring(0,3) === 'NCR')
#             {
#                  if(monto_oper<0) monto_oper *= -1;
#             }
#             else
#             {
#                  if(monto_oper>0) monto_oper *= -1;
#             }
#            //alert("Antes " + monto_antes + " .. Monto Oper " + monto_oper + " .. Comision " + mcomision);
#            //alert("DESPUES ... " + ((monto_antes + monto_oper) - mcomision).toFixed(2));
#            document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value = ((monto_antes + monto_oper) - mcomision).toFixed(2);
#            formatCurrency(document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value, 'movimiento_fideicomiso_saldo_disponible_despues');
#        }
#        else
#        {
#            //alert("Antes " + monto_antes + " .. Comision " + mcomision);
#            //alert("DESPUES ... " + (monto_antes - mcomision).toFixed(2));
#             document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value = (monto_antes - mcomision).toFixed(2);
#            formatCurrency(document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value, 'movimiento_fideicomiso_saldo_disponible_despues');
#        }

      @fid.destroy
      list
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Menu.menu850')
    @form_title_record = I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Mensajes.disponibilidad_fideicomiso')
    @form_title_records = I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Mensajes.disponibilidad_fideicomiso')
    @form_entity = 'fideicomiso'
    @form_identity_field = 'fideicomiso_id'
    @width_layout = '1240'
  end 
  
  private
  def fill_tipo_mov_manual
    @tipo_movimiento_manual_list = TipoMovimientoFideicomiso.find_by_sql("select id, case when tipo_nota = -1 then 'NCR' else 'NDB' end || '-' || motivo as tipo_movimiento_manual from tipo_movimiento_fideicomiso where modo_nota = 'MAN' order by tipo_nota desc,motivo")
  end
  def fill_entidad_financiera
    @entidad_financiera_list = EntidadFinanciera.find(:all,:conditions=>"activo=true", :order=>'nombre')    
  end
  def fideicomiso_fill(entidad_financiera_id)
    @nro_fideicomiso_list = Fideicomiso.find(:all, :conditions=>['entidad_financiera_id = ?', entidad_financiera_id], :order => 'numero_fideicomiso')
  end

  
end

