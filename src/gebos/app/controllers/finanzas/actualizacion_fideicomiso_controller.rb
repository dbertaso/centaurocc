# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Finanzas::ActualizacionFideicomisoController
# descripción: Migración a Rails 3
#

class Finanzas::ActualizacionFideicomisoController < FormTabsController

	skip_before_filter :set_charset, :only=>[:entidad_form_change,:entidad_change,:nro_fideicomiso_change,:tipo_m_change]

  def index
    #@tmf = TipoMovimientoFideicomiso.find(:all, :order => 'motivo')
    #list
    fill_tipo_mov_manual
    fill_entidad_financiera
    fideicomiso_fill(0)
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
      page.hide 'list' if params[:entidad_financiera_id] == '' 
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
  
  def nro_fideicomiso_change
    render :update do |page|
      if params[:nro_fideicomiso]==''
        @fideicomiso = []
        @tipo_movimiento_manual_list = []        
        page.hide 'list'
      else
        @fideicomiso = Fideicomiso.find_by_id(params[:nro_fideicomiso])
        @tipo_movimiento_manual_list = TipoMovimientoFideicomiso.find_by_sql("select *,case when tipo_nota = 1 then 'NCR' else 'NDB' end || ' - ' || motivo as tipo_movimiento_manual from tipo_movimiento_fideicomiso where modo_nota = 'MAN'")
        page.replace_html 'list', :partial => 'form'
        page.show 'list'
      end
    end
  end

  def tipo_m_change
    if params[:tipo_movimiento_fideicomiso_id]==''
      
      var_script="document.getElementById('movimiento_fideicomiso_monto_operacion').value='';"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_banco').value='';"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos').value='';"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos').value='';"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_sras').value='';"
      var_script+="document.getElementById('movimiento_fideicomiso_comision').value='0';"
      var_script+="document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value=document.getElementById('monto_disponible_actual').value;"
      
      var_script+="document.getElementById('movimiento_fideicomiso_monto_operacion_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_banco_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_sras_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_comision_display').innerHTML=formatCurrency2(0);"
      var_script+="document.getElementById('movimiento_fideicomiso_saldo_disponible_despues_display').innerHTML=formatCurrency2(document.getElementById('monto_disponible_actual').value);"
      

      var_script+="document.getElementById('afecta_sub_cuentas').value='S';"
      var_script+= "document.getElementById('movimiento_fideicomiso_monto_operacion').disabled=true;"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_banco').disabled=true;"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos').disabled=true;"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos').disabled=true;"
      var_script+="document.getElementById('movimiento_fideicomiso_monto_sras').disabled=true;"
      var_script+="document.getElementById('movimiento_fideicomiso_comision').disabled=true;"      

    else
        @tf=TipoMovimientoFideicomiso.find_by_id(params[:tipo_movimiento_fideicomiso_id])
        @formula = '"(' << (@tf.sub_cuenta_banco ? @tf.afecta_banco : '0').to_s << ' * B) + (' << (@tf.sub_cuenta_insumos ? @tf.afecta_insumos : '0').to_s << ' * I) + (' << (@tf.sub_cuenta_gastos ? @tf.afecta_gastos : '0').to_s << ' * G) + (' << (@tf.sub_cuenta_sras ? @tf.afecta_sras : '0').to_s << ' * S)";'
        var_script = "document.getElementById('movimiento_fideicomiso_monto_operacion').disabled=false;document.getElementById('formulaf').value=" << @formula << ";"
        afecta_sub = false
        unless @tf.nil?
          if @tf.sub_cuenta_banco 
            var_script+="document.getElementById('movimiento_fideicomiso_monto_banco').disabled=false;"
            afecta_sub = true
          else
            var_script+="document.getElementById('movimiento_fideicomiso_monto_banco').disabled=true;"
          end
          if @tf.sub_cuenta_insumos 
            afecta_sub = true
            var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos').disabled=false;"
          else
            var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos').disabled=true;"
          end
          if @tf.sub_cuenta_gastos 
            afecta_sub = true
            var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos').disabled=false;"
          else
            var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos').disabled=true;"
          end
          if @tf.sub_cuenta_sras 
            afecta_sub = true
            var_script+="document.getElementById('movimiento_fideicomiso_monto_sras').disabled=false;"
          else
            var_script+="document.getElementById('movimiento_fideicomiso_monto_sras').disabled=true;"
          end
          if @tf.comision
            var_script+="document.getElementById('movimiento_fideicomiso_comision').disabled=false;"
          else
            var_script+="document.getElementById('movimiento_fideicomiso_comision').disabled=true;"
          end
          var_script+="document.getElementById('movimiento_fideicomiso_monto_operacion').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_banco').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_sras').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_comision').value='';"
          var_script+="document.getElementById('movimiento_fideicomiso_saldo_disponible_despues').value=document.getElementById('monto_disponible_actual').value;"

          var_script+="document.getElementById('movimiento_fideicomiso_monto_operacion_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_banco_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_insumos_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_gastos_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_monto_sras_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_comision_display').innerHTML=formatCurrency2(0);"
          var_script+="document.getElementById('movimiento_fideicomiso_saldo_disponible_despues_display').innerHTML=formatCurrency2(document.getElementById('monto_disponible_actual').value);"
      

          var_script+="document.getElementById('afecta_d').value=" << (@tf.disponible ? '1' : '0') << ";"
          var_script+="document.getElementById('afecta_c').value=" << (@tf.comision ? '1' : '0') << ";"
          if afecta_sub 
            var_script+="document.getElementById('afecta_sub_cuentas').value='S';"
          else
            var_script+="document.getElementById('afecta_sub_cuentas').value='N';"
          end
        end
    end
    render :update do |page|
      page.<< var_script
    end
  end
  
  def save_new
    if params[:afecta_sub_cuentas] == 'S'
      valor_total = (params[:movimiento_fideicomiso][:monto_banco].nil? ? 0 : params[:movimiento_fideicomiso][:monto_banco]).to_f 
      valor_total= valor_total + (params[:movimiento_fideicomiso][:monto_insumos].nil? ? 0 : params[:movimiento_fideicomiso][:monto_insumos]).to_f 
      valor_total= valor_total + (params[:movimiento_fideicomiso][:monto_gastos].nil? ? 0 : params[:movimiento_fideicomiso][:monto_gastos]).to_f 
      valor_total= valor_total + (params[:movimiento_fideicomiso][:monto_sras].nil? ? 0 : params[:movimiento_fideicomiso][:monto_sras]).to_f 
      unless valor_total == params[:movimiento_fideicomiso][:monto_operacion].to_f
        render :update do |page|
         page.<<"varEnviado = false;"
         page.alert "#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Mensajes.monto_operacion_no_coincide_sub_cuentas')}"
        end
        return
      end
    else
      if params[:movimiento_fideicomiso][:monto_operacion].to_s.empty? || params[:movimiento_fideicomiso][:monto_operacion].to_i == 0
        render :update do |page|
         page.<<"varEnviado = false;"
         page.alert "#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Mensajes.monto_operacion_no_valido')}"
        end
        return
      end      
    end

    @fideicomisoMov = FideicomisoMovimientos.new(params[:movimiento_fideicomiso])
    @fideicomisoMov.fecha_movimiento = Time.now
    @fideicomisoMov.usuario_id = @usuario.id
    #@fideicomisoMov.fideicomiso_id = params[:fideicomiso_id];
    @tf = TipoMovimientoFideicomiso.find_by_id(@fideicomisoMov.tipo_movimiento_id)
    @fideicomiso=Fideicomiso.find_by_id(@fideicomisoMov.fideicomiso_id)
    @fideicomiso.monto_disponible=@fideicomisoMov.saldo_disponible_despues
    errores_fide = ""
      
  unless @tf.nil?
      unless @tf.sub_cuenta_banco.nil?
          if @fideicomiso.subcuenta_banco.nil? 
            @fideicomiso.subcuenta_banco = 0 
          end
        @fideicomiso.subcuenta_banco+=((@fideicomisoMov.monto_banco.nil? ? 0 : @fideicomisoMov.monto_banco).to_f * @tf.afecta_banco)
        logger.debug "da esto " << @fideicomiso.subcuenta_banco.to_s
        if @fideicomiso.subcuenta_banco < 0
          errores_fide += "  -#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.sub_cuenta_banco_no_negativo')} \n"
        end
      end
      unless @tf.sub_cuenta_insumos.nil?
          if @fideicomiso.subcuenta_insumos.nil? 
            @fideicomiso.subcuenta_insumos = 0 
          end
        @fideicomiso.subcuenta_insumos+=((@fideicomisoMov.monto_insumos.nil? ? 0 : @fideicomisoMov.monto_insumos).to_f * @tf.afecta_insumos)
        if @fideicomiso.subcuenta_insumos < 0
          errores_fide += "  -#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.sub_cuenta_insumo_no_negativo')} \n"
        end
      end
      unless @tf.sub_cuenta_gastos.nil?
          if @fideicomiso.subcuenta_gastos.nil? 
            @fideicomiso.subcuenta_gastos = 0 
          end
       @fideicomiso.subcuenta_gastos+=((@fideicomisoMov.monto_gastos.nil? ? 0 : @fideicomisoMov.monto_gastos).to_f * @tf.afecta_gastos)
         if @fideicomiso.subcuenta_gastos < 0
          errores_fide += "  -#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.sub_cuenta_gastos_no_negativo')} \n"
        end
     end
      unless @tf.sub_cuenta_sras.nil?
          if @fideicomiso.subcuenta_sras.nil? 
            @fideicomiso.subcuenta_sras = 0 
          end
        @fideicomiso.subcuenta_sras+=((@fideicomisoMov.monto_sras.nil? ? 0 : @fideicomisoMov.monto_sras).to_f * @tf.afecta_sras)
        if @fideicomiso.subcuenta_sras < 0
          errores_fide += "  -#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.sub_cuenta_sras_no_negativo')} \n"
        end
      end
  end
      if errores_fide != ''
        @fideicomisoMov = nil
        render :update do |page|
          page.<<"varEnviado = false;"
          page.alert "#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Errores.ocurrieron_siguientes_errores')}\n" << errores_fide
        end
        return
      end  
      @fideicomiso.fecha_ultima_actualizacion = Time.now
      if @fideicomisoMov.save  #@fideicomiso.update
      fideicomiso_fill(0)
      render :update do |page|
        page.<<"varEnviado = false;document.getElementById('entidad_financiera_id_').options[0].selected=true;document.getElementById('nro_fideicomiso_').options[0].selected=true;"
        page.hide 'list'
        page.replace_html 'message', "#{I18n.t('Sistema.Body.Modelos.TransaccionFideicomiso.Mensajes.movimiento_guardado_exito')}"
        page.show 'message'
        page.replace_html 'nro-fideicomiso-select', :partial => 'nro_fideicomiso_form_select'
        page.show 'nro-fideicomiso-select'
        page.<<"window.scrollTo(0,0)"
      end
    else
      render :update do |page|
         page.hide 'message'
         page.<<"varEnviado = false;"
        html=""
        html << "\t\t<ul>\n"
        @fideicomisoMov.errors.full_messages.each do |error|
          html << "\t\t\t<li>#{error}</li>\n"
        end
        html << "\t\t</ul>\n"
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p>" << html.html_safe << '</p>'.html_safe
        page.show 'errorExplanation'
      end
    end
  end 
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Menu.menu849')
    @form_search_expression = [] 
    @width_layout = '560'
  end

  private
  def fill_tipo_mov_manual
    @tipo_movimiento_manual_list = TipoMovimientoFideicomiso.find_by_sql("select id, case when tipo_nota = -1 then 'NCR' else 'NDB' end || '-' || motivo as tipo_movimiento_manual from tipo_movimiento_fideicomiso where modo_nota = 'MAN' order by tipo_nota desc,motivo")
  end
  def fill_entidad_financiera
    @entidad_financiera_list = EntidadFinanciera.find(:all, :conditions=>"activo=true", :order=>'nombre')    
  end
  def fideicomiso_fill(entidad_financiera_id)
    @nro_fideicomiso_list = Fideicomiso.find(:all, :conditions=>['entidad_financiera_id = ?', entidad_financiera_id], :order => 'numero_fideicomiso')
  end

  
  
end
