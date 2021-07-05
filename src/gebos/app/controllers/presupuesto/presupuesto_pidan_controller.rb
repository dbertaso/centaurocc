# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Presupuesto::PresupuestoPidanController
# descripción: Migración a Rails 3
#


class Presupuesto::PresupuestoPidanController < FormAjaxController

skip_before_filter :set_charset, :only=>[:sector_index_form_change, :sub_sector_index_form_change, :sub_rubro_index_form_change, :sector_change, :rubro_change, :rubro_change_destino, :rubro_change_origen, :sector_tra_orig_change, :sector_tra_dest_change, :sector_form_change, :programa_change]

 layout 'form_basic'

  def index
     @estado_index = Estado.find(:all, :order => 'nombre')
     @sector_index = Sector.find(:all, :conditions => 'activo=true', :order => 'nombre')
     @programa_list = Programa.find(:all,:conditions => 'activo=true', :order => 'nombre')
     @sub_sector_index = []
     @sub_rubro_list = []
     @rubro_index = []
     @sub_sector_list=[]
     @rubro_list=[]
     @sub_rubro_list=[]
    list
  end

  def list
    params['sort'] = "estado.nombre" unless params['sort']

     conditions = 'presupuesto_pidan.id > 0'
     @form_search_expression = []


   unless params[:programa_id].nil? 
      unless params[:programa_id][0].to_s==''
	 programa_id = params[:programa_id][0].to_s
	 programa = Programa.find(programa_id)
	 conditions << " and presupuesto_pidan.programa_id = #{programa_id} "
	 @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.programa_igual')} '#{programa.nombre}'"
      end
    end

    unless params[:estado_id].nil?
        unless params[:estado_id][0].to_s==''
          estado_id = params[:estado_id][0].to_s
          estado = Estado.find(estado_id)
          conditions << " and presupuesto_pidan.estado_id = #{params[:estado_id][0].to_i} "
	  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.estado_igual')} '#{estado.nombre}'"
        end
    end

    unless params[:sector_index_id].nil?
        unless params[:sector_index_id][0].to_s==''
          sector_id = params[:sector_index_id][0].to_s
          sector = Sector.find(sector_id)
          conditions << " and presupuesto_pidan.rubro_id in (select id from rubro where sector_id = #{params[:sector_index_id][0].to_s}) "
	  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre}'"
        end
    end


    unless params[:sub_sector_id].nil?
        unless params[:sub_sector_id][0].to_s==''
          sub_sector_id = params[:sub_sector_id][0].to_s
          sub_sector = SubSector.find(sub_sector_id)
          conditions << " and presupuesto_pidan.rubro_id in (select id from rubro where sub_sector_id = #{params[:sub_sector_id][0].to_s}) "
	  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{sub_sector.nombre}'"
        end
    end

    unless params[:rubro_id].nil?
        unless params[:rubro_id][0].to_s==''
          rubro_id = params[:rubro_id][0].to_s
          rubro = Rubro.find(rubro_id)
          conditions << " and presupuesto_pidan.rubro_id =  #{params[:rubro_id][0].to_s}"
	  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
        end
    end


    unless params[:sub_rubro_id].nil?
        unless params[:sub_rubro_id][0].to_s==''
          subrubro_id = params[:sub_rubro_id][0].to_s
          subrubro = SubRubro.find(subrubro_id)
          conditions << " and presupuesto_pidan.sub_rubro_id =  #{params[:sub_rubro_id][0].to_s}"
	  @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{subrubro.nombre}'"
        end
    end

    @list = PresupuestoPidan.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new

    @sector_list = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    @rubro_list=[]
    @sub_rubro_list=[]
    sector_fill(@sector_list[0].id)
    form_new @presupuesto_pidan
  end

  def save_new


    if params[:tipo_registro] == "carga"
    
      @presupuesto = PresupuestoPidan.find_by_programa_id_and_estado_id_and_rubro_id_and_sub_rubro_id(params[:presupuesto_carga][:programa_id],
      params[:presupuesto_carga][:estado_id],params[:presupuesto_carga][:rubro_id],params[:presupuesto_carga][:sub_rubro_id])
      
      unless @presupuesto.nil?
        render :update do |page|         
          page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.ya_existe',:programa_nombre=>@presupuesto.programa.nombre,:estado_nombre=>@presupuesto.estado.nombre,:sub_rubro_nombre=>@presupuesto.sub_rubro.nombre)#"El Presupuesto para el Programa: #{@presupuesto.programa.nombre}, en el Estado: #{@presupuesto.estado.nombre} para el Sub Rubro: #{@presupuesto.sub_rubro.nombre} ya existe."
          page.redirect_to :action=>'index'          
          page.<< "varEnviado=false "           
        end
        return false
      end
      
      @presupuesto_carga = PresupuestoCarga.new(params[:presupuesto_carga])
      @presupuesto_carga.usuario_id = session[:id]
      @presupuesto_carga.fecha_registro = Time.now
      if @presupuesto_carga.save
        @presupuesto_pidan = PresupuestoPidan.new()
        @presupuesto_pidan.estado_id = params[:presupuesto_carga][:estado_id]
        @presupuesto_pidan.disponibilidad =  params[:presupuesto_carga][:monto_presupuesto]
        @presupuesto_pidan.presupuesto =  params[:presupuesto_carga][:monto_presupuesto]
        @presupuesto_pidan.compromiso =  0
        @presupuesto_pidan.rubro_id =  params[:presupuesto_carga][:rubro_id]
        @presupuesto_pidan.sub_rubro_id =  params[:presupuesto_carga][:sub_rubro_id]
        @presupuesto_pidan.programa_id =  params[:presupuesto_carga][:programa_id]        
        success=@presupuesto_pidan.save
        
        if success
          render :update do |page|
            page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.se_creo',:programa_nombre=>@presupuesto_pidan.programa.nombre,:estado_nombre=>@presupuesto_pidan.estado.nombre,:sub_rubro_nombre=>@presupuesto_pidan.sub_rubro.nombre)
            page.<< "varEnviado=false "   
            page.redirect_to :action=>'index'             	
          end
        else
          render :update do |page|
            page.form_error
          end
          return false
        end
      else
        render :update do |page|
          page.form_error
        end
        return false
      end
    end
    if params[:tipo_registro] == "transferencia"      
 
       
      
      success = true
      
      @presupuesto_pidan=PresupuestoPidan.first
      if @presupuesto_pidan.parametros_verificacion(params)
      
       
       @presupuesto_pidan_origen = PresupuestoPidan.find_by_programa_id_and_estado_id_and_sub_rubro_id(params[:presupuesto_transferencia][:programa_id_origen],
      params[:presupuesto_transferencia][:estado_id_origen],params[:presupuesto_transferencia][:sub_rubro_id_origen])
 
       if @presupuesto_pidan_origen.nil?
        render :update do |page|
          page.<< "varEnviado=false "
          page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.no_se_puede_efectuar_transferencia')
          page.redirect_to :action=>'index'              	
        end
        return
      end
          
      
      
      @presupuesto_pidan_destino = PresupuestoPidan.find_by_programa_id_and_estado_id_and_sub_rubro_id(params[:presupuesto_transferencia][:programa_id_origen],
      params[:presupuesto_transferencia][:estado_id_destino],params[:presupuesto_transferencia][:sub_rubro_id_destino])
        
      if @presupuesto_pidan_destino.nil?
        render :update do |page|
          page.<< "varEnviado=false "
          page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.no_se_puede_efectuar_transferencia')
          page.redirect_to :action=>'index'
        end
        return
      end   
        
        
        
        @presupuesto_pidan_origen = PresupuestoPidan.find(:first, :conditions=>['programa_id = ? and sub_rubro_id = ? and estado_id = ?', 
                                              params[:presupuesto_transferencia][:programa_id_origen], params[:presupuesto_transferencia][:sub_rubro_id_origen],params[:presupuesto_transferencia][:estado_id_origen]])     
        logger.info "Presupuesto ========> #{@presupuesto_pidan_origen.inspect}"
        success &&= @presupuesto_pidan_origen.validar_transferencia(@presupuesto_pidan_origen.disponibilidad,params[:presupuesto_transferencia][:monto_transferencia])
       
      
      if !success
        render :update do |page|          
          #page.<< "varEnviado=false "
          #page.alert "No hay suficientes recursos en el Sub Rubro origen: #{@presupuesto_pidan_origen.sub_rubro.nombre} del Programa: #{@presupuesto_pidan_origen.programa.nombre} para llevar a cabo la transferencia"
          #page.redirect_to :action=>'index'
          page.form_error
        end
        return false
      end
        
      success = PresupuestoPidan.actualizar_transferencia(params, session[:id])
      if success        
            
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.transferencia_con_exito',:programa_nombre=>@presupuesto_pidan_origen.programa.nombre,:estado_nombre=>@presupuesto_pidan_origen.estado.nombre,:sub_rubro_nombre=>@presupuesto_pidan_origen.sub_rubro.nombre,:programa_nombre_destino=>@presupuesto_pidan_destino.programa.nombre,:estado_nombre_destino=>@presupuesto_pidan_destino.estado.nombre,:sub_rubro_nombre_destino=>@presupuesto_pidan_destino.sub_rubro.nombre)
          page.redirect_to :action=>'index'
        end
      else
        logger.info "ERRORES ==================> #{@errores.inspect}"
        render :update do |page|
          page.form_error
        end
        return false
      end
   else
	
	render :update do |page|
          page.form_error 
        end
        return false
   
   end #del if de verificacion de parametros
        
    end
  end

  def cancel_new
    form_cancel_new
  end

  def delete
    @presupuesto_pidan = PresupuestoPidan.find(params[:id])
    form_delete @presupuesto_pidan
  end

  def edit

    @presupuesto_pidan = PresupuestoPidan.find(params[:id])
    @presupuesto_carga = PresupuestoCarga.new()

    @sector_list = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    sector_fill(@presupuesto_pidan.rubro.sector_id)
    @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sector_id = ?',@presupuesto_pidan.rubro.sector_id], :order=>'nombre')

    @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?',@presupuesto_pidan.rubro.id], :order=>'nombre')


    form_edit @presupuesto_pidan
  end

  def save_edit
    @presupuesto_pidan = PresupuestoPidan.find(params[:id])

    @presupuesto_carga = PresupuestoCarga.new()
    @presupuesto_carga.rubro_id = @presupuesto_pidan.rubro_id
    @presupuesto_carga.sub_rubro_id = @presupuesto_pidan.sub_rubro_id
    @presupuesto_carga.estado_id = @presupuesto_pidan.estado_id
    @presupuesto_carga.usuario_id = session[:id]
    @presupuesto_carga.fecha_registro = Time.now
    @presupuesto_carga.monto_presupuesto =  params[:presupuesto_carga][:monto_presupuesto]
          if @presupuesto_carga.save
              @presupuesto_pidan.presupuesto = @presupuesto_pidan.presupuesto.to_f +  params[:presupuesto_carga][:monto_presupuesto].to_f
              @presupuesto_pidan.disponibilidad =  @presupuesto_pidan.disponibilidad.to_f +  params[:presupuesto_carga][:monto_presupuesto].to_f
              success=@presupuesto_pidan.save
              if success
                render :update do |page|
                  page.alert I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Mensajes.se_actualizo',:programa_nombre=>(@presupuesto_pidan.programa.nil? ? "'Sin programa'" : @presupuesto_pidan.programa.nombre),:estado_nombre=>@presupuesto_pidan.estado.nombre,:sub_rubro_nombre=>@presupuesto_pidan.sub_rubro.nombre)#"El Presupuesto para el programa #{(@presupuesto_pidan.programa.nil? ? "'Sin programa'" : @presupuesto_pidan.programa.nombre)} en el Estado: #{@presupuesto_pidan.estado.nombre} para el Sub Rubro: #{@presupuesto_pidan.sub_rubro.nombre} se ha Actualizado con Éxito."                 	
                  page.redirect_to :action=>'index'
                end
              else
                render :update do |page|
                  page.form_error
                  #page.alert 'noooooo'
                end
                return false              
              end
          else
              render :update do |page|
                    page.form_error
                    #page.alert I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')
              end
              return false
          end
  end

  def cancel_edit
    @presupuesto_pidan = PresupuestoPidan.find(params[:id])
    form_cancel_edit @presupuesto_pidan
  end

  def programa_change
    @nombre_moneda = Programa.find(params[:id]).moneda.nombre
    render :update do |page|
      if params[:valor].to_i == 1
        page.replace_html 'programa-select', @nombre_moneda
        page.show 'programa-select'
      else
        page.replace_html 'programa1-select', @nombre_moneda
        page.show 'programa1-select'
      end
    end
  end

  def sector_index_form_change
    @sub_sector_list=sub_sector_index_fill(params[:sector_index_id])
    rubro_index_fill(0)
    sub_rubro_index_fill(0)
    render :update do |page|
      page.replace_html 'sub-sector-index-select', :partial => 'sub_sector_form_select'
      page.replace_html 'rubro-index-select', :partial => 'rubro_index_form_select'
      page.replace_html 'sub-rubro-index-select', :partial => 'sub_rubro_index_form_select'
      page.show 'sub-sector-index-select'
      page.show 'rubro-index-select'
      page.show 'sub-rubro-index-select'
    end
  end
  def sub_sector_index_fill(sector_id)
    if sector_id.to_s.length > 0
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', sector_id],:order => 'nombre')

    else
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo=true and sector_id = ?', 0],:order => 'nombre')
      #rubro_fill(0)
    end
  end
  def sub_sector_index_form_change
    rubro_index_fill(params[:sub_sector_id])
    sub_rubro_index_fill(0)
    render :update do |page|
      page.replace_html 'rubro-index-select', :partial => 'rubro_index_form_select'
      page.replace_html 'sub-rubro-index-select', :partial => 'sub_rubro_index_form_select'
      page.show 'rubro-index-select'
      page.show 'sub-rubro-index-select'
    end
  end



  def sub_rubro_index_form_change
      if params[:rubro_id]!=""
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', params[:rubro_id]],:order => 'nombre')
      else
        @sub_rubro_list =[]
      end
    render :update do |page|
      page.replace_html 'sub-rubro-index-select', :partial => 'sub_rubro_index_form_select'
      page.show 'sub-rubro-index-select'
    end
  end



   def rubro_index_fill(sub_sector_id)
      if sub_sector_id!=""
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sub_sector_id = ?', sub_sector_id],:order => 'nombre')
      else
      @rubro_list =[]
      end
   end

   def sub_rubro_index_fill(rubro_id)
      if rubro_id!=""
      @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and rubro_id = ?', rubro_id],:order => 'nombre')
      else
      @sub_rubro_list =[]
      end
   end


  def sector_change

    if params[:estado_id]!=""


        rubro_fill(params[:sector_id], params[:estado_id])
        sub_rubro_index_fill(0)
        render :update do |page|
          page.replace_html 'rubro-select', :partial => 'rubro_select'
          page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
          page.show 'rubro-select'
          page.show 'sub-rubro-select'
        end
    else

          render :update do |page|
          page.alert "#{I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Header.debe_seleccionar_estado')}"

        end
    end
  end



  def rubro_change
      if params[:rubro_id]!=""
     #@sub_rubro_list = SubRubro.find(:all, :conditions=>['id not in (select sub_rubro_id from presupuesto_pidan where estado_id = ? and  rubro_id = ?) and rubro_id #= ?',params[:estado_id],params[:rubro_id],params[:rubro_id]],:order => 'nombre')
     @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and id not in (select sub_rubro_id from presupuesto_pidan where estado_id = ? and  rubro_id = ? and programa_id = ?) and rubro_id = ?',params[:estado_id],params[:rubro_id],params[:programa_id],params[:rubro_id]],:order => 'nombre')
      else
     @sub_rubro_list =[]

      end

    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
      page.show 'sub-rubro-select'
    end
  end


  def rubro_change_destino
      if params[:rubro_id]!=""
     @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and id in (select sub_rubro_id from presupuesto_pidan where estado_id = ? and rubro_id = ?) and rubro_id = ?',params[:estado_id],params[:rubro_id],params[:rubro_id]],:order => 'nombre')
      else
      @sub_rubro_list =[]
      end
    render :update do |page|
      page.replace_html 'sub-rubro-select-tra-dest', :partial => 'sub_rubro_select_tra_dest'
      page.show 'sub-rubro-select-tra-dest'
    end
  end

  def rubro_change_origen
    if params[:rubro_id]!=""

     @sub_rubro_list = SubRubro.find(:all, :conditions=>['activo=true and id in (select sub_rubro_id from presupuesto_pidan where estado_id = ? and rubro_id = ?) and rubro_id = ?',params[:estado_id],params[:rubro_id],params[:rubro_id]],:order => 'nombre')
    else
     @sub_rubro_list =[]
    end
    render :update do |page|
      page.replace_html 'sub-rubro-select-tra-orig', :partial => 'sub_rubro_select_tra_orig'
      page.show 'sub-rubro-select-tra-orig'
    end
  end




  def sector_tra_orig_change
    if params[:estado_id]!=""

        rubro_transferencia_fill(params[:sector_id],params[:estado_id])
        sub_rubro_index_fill(0)
        render :update do |page|
          page.replace_html 'rubro-select-tra-orig', :partial => 'rubro_origen_select'
          page.replace_html 'sub-rubro-select-tra-orig', :partial => 'sub_rubro_select_tra_orig'
          page.show 'rubro-select-tra-orig'
          page.show 'sub-rubro-select-tra-orig'
        end
    else

          render :update do |page|
          page.alert "#{I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Header.debe_seleccionar_estado')}"
          end
    end


  end



 def sector_tra_dest_change

    if params[:estado_id]!=""

        rubro_transferencia_fill(params[:sector_id],params[:estado_id])
        sub_rubro_index_fill(0)
        render :update do |page|
          page.replace_html 'rubro-select-tra-dest', :partial => 'rubro_destino_select'
          page.replace_html 'sub-rubro-select-tra-dest', :partial => 'sub_rubro_select_tra_orig'
          page.show 'rubro-select-tra-dest'
          page.show 'sub-rubro-select-tra-dest'
        end
    else

          render :update do |page|
          page.alert "#{I18n.t('Sistema.Body.Vistas.PresupuestoPidan.Header.debe_seleccionar_estado')}"
          end
    end
  end

  def sector_form_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_form_select'
      page.show 'rubro-select'
    end
  end


  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.PresupuestoPidan.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PresupuestoPidan.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PresupuestoPidan.FormTitles.form_title_records')
    @form_entity = 'presupuesto_pidan'
    @form_identity_field = 'nombre'
    @estado_list = Estado.find(:all, :order=>'nombre')
    @programa_list = Programa.find(:all,:conditions => 'activo=true', :order => 'nombre')
    @width_layout = '1200'
  end

  def sector_fill(sector_id)

      @sector_list = Sector.find(:all,:conditions=>"activo=true" ,:order=>'nombre')
      #rubro_fill(@sector_list[0].id,)
    end


    def rubro_fill(sector_id,estado_id)
      if sector_id!=""
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sector_id = ?',sector_id],:order => 'nombre')
      else
        @rubro_list =[]
      end

    end

    def rubro_transferencia_fill(sector_id,estado_id)

      if sector_id!=""
      @rubro_list = Rubro.find(:all, :conditions=>['activo=true and sector_id = ?',sector_id],:order => 'nombre')
      else
        @rubro_list =[]
      end

    end
end
