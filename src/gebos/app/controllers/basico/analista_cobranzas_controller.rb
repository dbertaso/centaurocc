# encoding: utf-8
class Basico::AnalistaCobranzasController < FormTabsController
  
   skip_before_filter :set_charset, :only=>[:check_ci_new, :sector_search, :sub_sector_search, :sector_change, :sub_sector_change]
  
  layout 'form_basic'
  
  def index
    sector_fill
  end

  def list
    params['sort'] = "analista_cobranzas.primer_nombre" unless params['sort']
    conditions = "analista_cobranzas.id > 0"
    unless params[:cedula].blank?
      conditions << " and cedula = #{params[:cedula]} and letra_cedula ='#{params[:letra_cedula]}'"
    end

    unless params[:primer_nombre].blank?
      conditions << " AND LOWER(primer_nombre) LIKE '%#{params[:primer_nombre].strip.downcase}%'"
    end

    unless params[:primer_apellido].blank?
      conditions << " AND LOWER(primer_apellido) LIKE '%#{params[:primer_apellido].strip.downcase}%'"
    end


    unless params[:sector_id].blank? || params[:sector_id].to_i == 0
     conditions << " AND sector_id = #{params[:sector_id]}"
    end

    unless params[:sub_sector_id].blank? || params[:sub_sector_id].to_i == 0
      conditions << " AND sub_sector_id =#{params[:sub_sector_id]}"
    end
    
    @list = AnalistaCobranzas.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def check_ci_new
   if (params[:cedula].nil? || params[:cedula].blank?)
      render :update do |page|
        page.alert I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.Errores.debe_introducir_cedula')
      end
      return false
   else
      usu = Usuario.count(:all, :conditions=>"cedula_nacionalidad = '#{params[:letra_cedula]}' and cedula = #{params[:cedula]}")
      if usu == 0
        render :update do |page|
            page.alert I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.Errores.usuario_no_registrado')
        end
        return false
      else
         tec = AnalistaCobranzas.count(:all, :conditions=>"letra_cedula = '#{params[:letra_cedula]}' and cedula = #{params[:cedula]}")
         if tec > 0
           render :update do |page|
            page.alert page.alert I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.Errores.analista_ya_registrado')
           end
           return false
         else
           letra = params[:letra_cedula].to_s
           numero = params[:cedula]
         end
      end 
   end
   if letra && numero
        render :update do |page|
          page.redirect_to :action=>'new', :cedula=>numero, :letra=>letra, :popup=>params[:popup]
        end
    else
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.Errores.debe_introducir_cedula')
        end
    end
  end
  
  
  def view
    @analista_cobranzas = AnalistaCobranzas.find(params[:id])

  end
 
  def new
    @usuario = Usuario.find(:first, :conditions=>"cedula_nacionalidad = '#{params[:letra]}' and cedula = #{params[:cedula]} and activo = TRUE")
    @analista_cobranzas = AnalistaCobranzas.new
    @analista_cobranzas.letra_cedula = @usuario.cedula_nacionalidad
    @analista_cobranzas.cedula = @usuario.cedula
    @analista_cobranzas.primer_nombre = @usuario.primer_nombre
    @analista_cobranzas.segundo_nombre = @usuario.segundo_nombre
    @analista_cobranzas.primer_apellido = @usuario.primer_apellido
    @analista_cobranzas.segundo_apellido = @usuario.segundo_apellido
    @analista_cobranzas.usuario_id = @usuario.id
    sector_fill
  end

  def save_new
    @analista_cobranzas = AnalistaCobranzas.new(params[:analista_cobranzas])
    form_save_new @analista_cobranzas 
    sector_fill
  end
  
  def delete
    @analista_cobranzas = AnalistaCobranzas.find(params[:id])
    result = @analista_cobranzas.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @analista_cobranzas, 'analista_cobranzas'
      end
    end
  end
  
  def edit
    @analista_cobranzas = AnalistaCobranzas.find(params[:id])
    sector_fill
  end
  
  def save_edit
    @analista_cobranzas = AnalistaCobranzas.find(params[:id])
    form_save_edit @analista_cobranzas
    sector_fill
  end

  def sector_search

    #logger.debug "Sector =========> " << params.inspect
    #puts "Sector =========> " << params.inspect

    @sub_sector_select = SubSector.all(:conditions => "sector_id = #{params[:id].to_s} ", :order => "nombre")

    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end


  def sector_change

    #puts "Sector =========> " << params.inspect
    if params[:id]!=""
    @sub_sector_select = SubSector.find_by_sql("select id,nombre from sub_sector where sector_id = #{params[:id].to_s} order by nombre")
    else
      @sub_sector_select =[]
    end
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'
    end
  end

  def sub_sector_change

    #puts "Sub_Sector =========> " << params.inspect
    if params[:id]!=""
    sub_sector = SubSector.find(params[:id])

    @rubro_select = Rubro.all(:conditions=>"sector_id = #{sub_sector.sector_id} and sub_sector_id = #{params[:id].to_s} and activo = true", :order=>"nombre")
    else

      @rubro_select =[]
     end
    #puts "RUBRO ========> " << @rubro_select.inspect
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
    end
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.FormTitles.form_title')
    @form_title_record   = I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.FormTitles.form_title_record')
    @form_title_records  = I18n.t('Sistema.Body.Controladores.AnalistaCobranzas.FormTitles.form_title_records')
    @form_entity         = 'analista_cobranzas'
    @form_identity_field = 'analista'
    @width_layout        = '800'
  end

  def sector_fill

    @sector_select = Sector.all(:order=>"nombre")
    @sub_sector_select = SubSector.all(:order=>"nombre")

  end

  private

end
