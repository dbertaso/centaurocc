# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::CondicionesFinanciamientoController
# descripción: Migración a Rails 3

class Basico::CondicionesFinanciamientoController < FormClassicController

  skip_before_filter :set_charset, :only=>[:programa_change, :sector_change, :sub_sector_change, :rubro_change, :sub_rubro_change, :programa_search, :sector_search, :sub_sector_search, :rubro_search, :sub_rubro_search]

  def index

    sector_fill()
    #logger.info "Sector Select =======> #{@sector_select.inspect}"
    @rubro_select=[]
    @actividad_select=[]
    @sub_rubro_select=[]

  end

  def list

    params['sort'] = "rubro.codigo" unless params['sort']

    conditions = ""

    unless params[:programa_id].nil? || params[:programa_id].to_s.empty? || params[:programa_id].to_i == 0
      conditions = " condiciones_financiamiento.programa_id = #{params[:programa_id].to_s}"
      if params[:programa_id].to_i >  0
        programa = Programa.find(params[:programa_id].to_i)
        @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.Contabilidad.ReglaContable.FormSearch.programa_igual')} #{programa.nombre}"
      end
    end

    if params[:sector_id] != '0'
      unless params[:sector_id].nil? || params[:sector_id].to_i == 0
        @sector = Sector.find(params[:sector_id])
        conditions += " and condiciones_financiamiento.sector_id = #{params[:sector_id].to_s}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{@sector.nombre}'"
      end
    end

    if params[:sub_sector_id] != '0'
      unless params[:sub_sector_id].nil? || params[:sub_sector_id].to_i == 0
        @sub_sector = SubSector.find(params[:sub_sector_id])
        conditions += " and condiciones_financiamiento.sub_sector_id =  #{params[:sub_sector_id].to_s}"
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{@sub_sector.nombre}'"
      end
    end

    if params[:rubro_id] != '0'
      unless params[:rubro_id].nil? || params[:rubro_id].to_i == 0
        @rubro = Rubro.find(params[:rubro_id])
        conditions += " and condiciones_financiamiento.rubro_id =  #{params[:rubro_id].to_s} "
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{@rubro.nombre}'"
      end
    end

    if params[:sub_rubro_id] != '0'
      logger.info "Parametros ==========> #{params.inspect}"
      unless params[:sub_rubro_id].nil? || params[:sub_rubro_id].empty?
        conditions += " and condiciones_financiamiento.sub_rubro_id = #{params[:sub_rubro_id]}"
        subrubro = SubRubro.find(params[:sub_rubro_id].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{subrubro.nombre}'"
      end
    end


    if params[:actividad_id] != '0'
      logger.info "Parametros ==========> #{params.inspect}"
      unless params[:actividad_id].nil? || params[:actividad_id].empty?
        conditions += " and condiciones_financiamiento.actividad_id = #{params[:actividad_id]}"
        actividad = Actividad.find(params[:actividad_id].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.actividad_igual')} '#{actividad.nombre}'"
      end
    end

    @list = CondicionesFinanciamiento.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def new
    sector_fill()
    @rubro_select=[]
    @actividad_select=[]
    @sub_rubro_select=[]
    @plazo_total = 0
    @condiciones_financiamiento = CondicionesFinanciamiento.new
    @condiciones_financiamiento.periodo_gracia = 0
  end

  def save_new

    @condiciones_financiamiento = CondicionesFinanciamiento.new(params[:condiciones_financiamiento])
    form_save_new @condiciones_financiamiento
  end

  def delete
    @condiciones_financiamiento = CondicionesFinanciamiento.find(params[:id])
    form_delete @condiciones_financiamiento
  end

  def edit
    sector_fill()
    @sub_rubro_select = SubRubro.all(:order=>"nombre")
    @actividad_select = Actividad.all(:order=>"nombre")
    @condiciones_financiamiento = CondicionesFinanciamiento.find(params[:id])
    @plazo_total = @condiciones_financiamiento.plazo_total
  end

  def view
     @condiciones_financiamiento = CondicionesFinanciamiento.find(params[:id])
     @plazo_total = @condiciones_financiamiento.plazo_total
  end

  def save_edit

    @condiciones_financiamiento = CondicionesFinanciamiento.find(params[:id])
    form_save_edit @condiciones_financiamiento
  end

  def sub_sector_search

    #puts "Sub_Sector =========> " << params.inspect
    if params[:id] !="0"
    sub_sector = SubSector.find(params[:id])

    @rubro_select = Rubro.all(:conditions=>"sector_id = #{sub_sector.sector_id} and sub_sector_id = #{params[:id].to_s} and activo = true", :order=>"nombre")
    else

    @rubro_select =[]
    end
    #puts "RUBRO ========> " << @rubro_select.inspect
    render :update do |page|
      page.replace_html 'rubro-search', :partial => 'rubro_search'
    end


  end

  def programa_search

    logger.debug "Programa =========> " << params.inspect
    puts "Programa =========> " << params.inspect

    @sector_select = Sector.all(:conditions => "id in (select sector_id from producto where programa_id = #{params[:id].to_s}) ", :order => "nombre")
    logger.debug "Cantidad de registros: =========> #{@sector_select.count.to_s}"
    render :update do |page|
      page.replace_html 'sector-search', :partial => 'sector_search'
    end
  end

  def sector_search

    logger.debug "Sector =========> " << params.inspect
    puts "Sector =========> " << params.inspect

    @sub_sector_select = SubSector.all(:conditions => "sector_id = #{params[:id].to_s} ", :order => "nombre")

    render :update do |page|
      page.replace_html 'sub-sector-search', :partial => 'sub_sector_search'
    end
  end

  def programa_change

    #puts "Sector =========> " << params.inspect
    if params[:id]!=""
      conditions = ""
      conditions = "id in (select sector_id from producto where programa_id = #{params[:id].to_s}) "
      #conditions += "and id not in (select sector_id from condiciones_financiamiento where programa_id = #{params[:id].to_s})"
      @sector_select = Sector.all(:conditions => conditions, :order => "nombre")
    else
      @sector_select =[]
    end
    render :update do |page|
      page.replace_html 'sector-select', :partial => 'sector_select'
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


  def rubro_change

    #puts "Sub_Sector =========> " << params.inspect
    if params[:id]!=""
    @sub_rubro_select = SubRubro.all(:conditions => "rubro_id = #{params[:id].to_s} ", :order => "nombre")
    else
    @sub_rubro_select = []
    end
    #puts "RUBRO ========> " << @rubro_select.inspect
    render :update do |page|
      page.replace_html 'sub-rubro-select', :partial => 'sub_rubro_select'
    end
  end


  def sub_rubro_change

    if params[:id]!="0"
    @actividad_select = Actividad.all(:conditions => "sub_rubro_id = #{params[:id].to_s} ", :order => "nombre")
      else
       @actividad_select = []
      end
    render :update do |page|
      page.replace_html 'actividad-select', :partial => 'actividad_select'
    end
  end


  def rubro_search

    logger.debug "Rubro =========> " << params.inspect
    puts "Rubro =========> " << params.inspect

    if params[:id] != "0"
      @sub_rubro_select = SubRubro.all(:conditions => "rubro_id = #{params[:id].to_s} ", :order => "nombre")
    else
      @sub_rubro_select =[]
    end
      render :update do |page|
      page.replace_html 'sub-rubro-search', :partial => 'sub_rubro_search'
    end
  end

  def sub_rubro_search

    if params[:id]!="0"
      @actividad_select = Actividad.all(:conditions => "sub_rubro_id = #{params[:id].to_s} ", :order => "nombre")
    else
      @actividad_select =[]
    end
      render :update do |page|
      page.replace_html 'actividad-search', :partial => 'actividad_search'
    end
  end


  def sector_fill

    @sector_select = Sector.all(:order=>"nombre")
    @sub_sector_select = SubSector.all(:order=>"nombre")
    @rubro_select = Rubro.all(:order=>"nombre")
    @formula_list =  Formula.all(:order=>"id")
    @programa_list = Programa.find(:all, :order=>'nombre')

  end

  protected

  def common
    super
      @form_title = I18n.t('Sistema.Body.Controladores.CondicionesFinanciamiento.FormTitles.form_title')
      @form_title_record = I18n.t('Sistema.Body.Controladores.CondicionesFinanciamiento.FormTitles.form_title_record')
      @form_title_records = I18n.t('Sistema.Body.Controladores.CondicionesFinanciamiento.FormTitles.form_title_records')
      @form_entity = 'condiciones_financiamiento'
      @form_identity_field = 'id'
      @width_layout = '1350'
  end

  private


end
