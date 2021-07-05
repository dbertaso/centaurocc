# encoding: UTF-8

# autor: Marvin Alfonzo
# clase: Solicitudes::ConsultaCertificacionPresupuestariaController
# descripción: Migración a Rails 3
#

class Solicitudes::ConsultaCertificacionPresupuestariaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:sector_change,:sub_sector_change,:rubro_change,:sub_rubro_change,:liberar]

 #layout 'form_basic'

  def index
    @programa_list = Programa.find(:all, :conditions => 'activo=true', :order => 'nombre')
    @estado = Estado.find(:all, :order => 'nombre')
    fill
    @estatus = Estatus.find(:all, :order => 'nombre')
  end

  def liberar
   
    if params[:cuenta_id].to_s==''      
      render :update do |page|        
        page.replace_html 'errorExplanation', "<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>" << I18n.t('Sistema.Body.Vistas.ConsultaCertificacionPresupuestaria.Etiquetas.debe_seleccionar_tramite') << "</LI>" 
        page.show 'errorExplanation'
      end
    else
      solicitudes = params[:cuenta_id].split(',')
      codigo,ids = PresupuestoPidan.liberar(solicitudes,@usuario.id)      
      case codigo
      when 0
        #list_reload
        render :update do |page|          
          page.hide 'errores'
          solicitudes.each{|sol|
            page.remove "row_#{sol}"
          }          
          page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'          
          page.hide 'errorExplanation'
          page.replace_html 'message', I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.se_actualizaron_con_exito')
          page.show 'message'          
        end
            
      when 1
        render :update do |page|
          page.hide 'mensaje'
          page.hide 'errores'
          page.<< 'document.getElementById("cuenta_id").value = "";document.getElementById("cuenta_id1").value = "";'
          page.replace_html 'errores', "<div class=\"msg-notice\" id=\"error\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Vistas.ConsultaCertificacionPresupuestaria.Etiquetas.no_existe_tramite')}</div>"
          page.show 'errores'
        end
      end
    end
  
  end

  def list
    estatus_id = 10010
    conditions = "estatus_id = #{estatus_id}"
    estatus = Estatus.find(estatus_id)
    @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estatus_igual')} '#{estatus.nombre}'"

    params['sort'] = "estado" unless params['sort']    
    unless params[:estado_id].nil? 
      unless params[:estado_id][0].to_s==''
      estado_id = params[:estado_id][0].to_s
      estado = Estado.find(estado_id)
      conditions += "  AND estado_id =  #{estado_id }"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{estado.nombre}'"
      end
    end

    unless params[:sector_id].nil? 
      unless params[:sector_id][0].to_s==''
      sector_id = params[:sector_id][0].to_s
      sector = Sector.find(sector_id)
      conditions += " AND sector_id =  #{sector_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
      end
    end

    unless params[:sub_sector_id].nil? 
      unless params[:sub_sector_id][0].to_s==''
      sub_sector_id = params[:sub_sector_id][0].to_s
      sub_sector = SubSector.find(sub_sector_id)
      conditions += " AND sub_sector_id =  #{sub_sector_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{sub_sector.nombre}'"
      end
    end

    unless params[:rubro_id].nil? 
      unless params[:rubro_id][0].to_s==''
      rubro_id = params[:rubro_id][0].to_s
      rubro = Rubro.find(rubro_id)
      conditions += " AND rubro_id =  #{rubro_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
      end
    end
            

    unless params[:sub_rubro_id].nil? 
      unless params[:sub_rubro_id][0].to_s==''
      sub_rubro_id = params[:sub_rubro_id][0].to_s
      subrubro = SubRubro.find(sub_rubro_id)
      conditions += " AND sub_rubro_id =  #{sub_rubro_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{subrubro.nombre}'"
      end
    end


    unless params[:actividad_id].nil? 
      unless params[:actividad_id][0].to_s==''
      actividad_id = params[:actividad_id][0].to_s
      actividad = Actividad.find(actividad_id)
      conditions += " AND actividad_id =  #{actividad_id}"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
      end
    end

    unless params[:programa_id].nil? 
      unless params[:programa_id][0].to_s==''
      programa_id = params[:programa_id][0].to_s
      programa = Programa.find(programa_id)
      conditions += " and programa_id = #{programa_id} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.programa_igual')} '#{programa.nombre}'"
      end
    end
    
    unless params[:numero].to_s.nil? || params[:numero].to_s.empty?
      conditions += " and numero = #{params[:numero]} "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_tramite')} '#{params[:numero]}'"
    end
    
    unless params[:cedula_rif].to_s.nil? || params[:cedula_rif].to_s.empty?
      conditions +=" and cedula_rif LIKE UPPER('%#{params[:cedula_rif]}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.cedula_rif_contenga')} '#{params[:cedula_rif]}'"
    end
    
    unless params[:productor].to_s.nil? || params[:productor].to_s.empty?
      conditions += " and productor LIKE UPPER('%#{params[:productor]}%') "
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.beneficiario_igual')} '#{params[:productor]}'"
    end

    
    @list = ViewPendientePorDisponibilidad.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    condicion_rol = " usuario_rol.rol_id = 7 "
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    form_list

  end




  def view
    @solicitud = Solicitud.find(params[:id])
    @cliente = @solicitud.cliente
    @accion = params[:accion]
    @historial = DetalleReestructuracion.find(:all, :conditions=>["solicitud_id = ?", @solicitud.id])
  end
  
  def sector_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|            
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
      page.replace_html 'rubro-search', :partial => 'rubro_search'
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
  
  def sub_sector_change
    rubro_fill(params[:sub_sector_id])
    #@rubro_list = Rubro.find(:all, :conditions=>"activo=true and sub_sector_id = #{params[:sub_sector_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
  
  def rubro_change
    sub_rubro_fill(params[:rubro_id])
    #@sub_rubro_list = SubRubro.find(:all, :conditions=>"activo=true and rubro_id = #{params[:rubro_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
  
  def sub_rubro_change
    actividad_fill(params[:sub_rubro_id])
    #@actividad_list = Actividad.find(:all, :conditions=>"activo=true and sub_rubro_id = #{params[:sub_rubro_id]}", :order=>'nombre')
    render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end
  
  def list_reload
    cond = params[:condition].to_s.split(',')
    conditions = "estatus_id = 10010"
    
    params['sort'] = "estado" unless params['sort']    
    unless cond[1].to_s.nil? || cond[1].to_s.empty?
      conditions += "  AND estado_id =  #{cond[1]}"
    end
    unless cond[0].to_s.nil? || cond[0].to_s.empty?
      conditions = conditions << " and programa_id = #{cond[0]} "
    end

    unless cond[2].to_s.nil? || cond[2].to_s.empty?
      conditions += " AND sector_id =  #{cond[2]}"
    end

    unless cond[3].to_s.nil? || cond[3].to_s.empty?
      conditions += " AND sub_sector_id =  #{cond[3]}"
    end

    unless cond[4].to_s.nil? || cond[4].to_s.empty?
      conditions += " AND rubro_id =  #{cond[4]}"
    end
            

    unless cond[5].to_s.nil? || cond[5].to_s.empty?
      conditions += " AND sub_rubro_id =  #{cond[5]}"
    end


    unless cond[6].to_s.nil? || cond[6].to_s.empty?
      conditions += " AND actividad_id =  #{cond[6]}"
    end
    
    unless cond[7].to_s.nil? || cond[7].to_s.empty?
      conditions += " AND numero =  #{cond[7]}"
    end
            

    unless cond[8].to_s.nil? || cond[8].to_s.empty?
      conditions += " AND cedula_rif LIKE UPPER('#{cond[8]}%')"
    end


    unless cond[9].to_s.nil? || cond[9].to_s.empty?
      conditions += " AND productor LIKE UPPER('%#{cond[9]}%')"
    end

    @list = ViewPendientePorDisponibilidad.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count
    condicion_rol = " usuario_rol.rol_id = 7 "
    @aux_roles = @usuario.roles.find(:first, :conditions=>condicion_rol)
    form_list_reload
  end

  def fill
    @sector_list = Sector.find(:all,:conditions=>"activo=true", :order=>'nombre')
    sub_sector_fill(0)
  end
  
  def sub_sector_fill(sector_id)
    if (sector_id.to_i > 0)
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id.to_i], :order=>'nombre')
    else
      @sub_sector_list = []      
    end
    rubro_fill(0)
  end
  
  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id.to_i], :order=>'nombre')
    else
      @rubro_list = []
    end
    sub_rubro_fill(0)
  end
  
  def sub_rubro_fill(rubro_id)
    if rubro_id.to_i  > 0
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', rubro_id.to_i], :order=>'nombre')
    else
      @sub_rubro_list = []      
    end
    actividad_fill(0)
  end
  
  def actividad_fill(sub_rubro_id)
    if sub_rubro_id.to_i  > 0
      @actividad_list = Actividad.find(:all, :conditions=>['activo=true and sub_rubro_id = ?', sub_rubro_id.to_i], :order=>'nombre')
    else
      @actividad_list = []
    end
  end


  protected
  def common
    super
    #@form_title = Etiquetas.etiqueta(10)
    @form_title = "#{I18n.t('Sistema.Body.Controladores.PresupuestoPidan.FormTitles.form_title_record')} - #{I18n.t('Sistema.Body.Modelos.General.pendiente_por_disponibilidad')}"
    @form_title_record = I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.solicitudes')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ParametroGeneral.Separadores.solicitudes')
    @form_entity = 'view_pendiente_por_disponibilidad'
    @form_identity_field = 'numero'
    @width_layout = '1180'
  end
  
  
     
end

