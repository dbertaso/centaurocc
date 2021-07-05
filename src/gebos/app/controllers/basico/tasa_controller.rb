# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::TasaController
# descripción: Migración a Rails 3
#

class Basico::TasaController < FormTabsController

  skip_before_filter :set_charset, :only=>[:sector_tasa_change, :sector_tasa_change_list, :sub_sector_tasa_change, :sub_sector_tasa_change_list, :rubro_tasa_change, :rubro_tasa_change_list]

  def index
    @sector_list = Sector.find(:all, :conditions=>'activo = true', :order=>'nombre')
    @sub_sector_list =[]
    @rubro_list =[]
    @sub_rubro_list =[]
  end

  def list

    params['sort'] = "tasa.nombre" unless params['sort']
    conditions = "sub_rubro_id > 0 "

    unless params[:sector_id][0].nil? || params[:sector_id][0] == ""
      conditions = "#{conditions} and sector_id =  #{params[:sector_id][0]} "
      sector = Sector.find(params[:sector_id][0].to_i)
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sector_igual')} '#{sector.nombre.to_s}'"
    end

    unless params[:sub_sector].nil?
      unless params[:sub_sector_id][0].nil? || params[:sub_sector_id][0] == ""
        conditions = "#{conditions} and sub_sector_id =  #{params[:sub_sector_id][0]} "
        sub_sector = SubSector.find(params[:sub_sector_id][0].to_i)
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_sector_igual')} '#{sub_sector.nombre}'"
      end
    end

    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].nil? || params[:rubro_id][0] == ""
        conditions = "#{conditions} and rubro_id =  #{params[:rubro_id][0]} "
        rubro = Rubro.find(params[:rubro_id][0])
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.rubro_igual')} '#{rubro.nombre}'"
      end
    end

    unless params[:sub_rubro_id].nil?
      unless params[:sub_rubro_id][0].nil? || params[:sub_rubro_id][0] == ""
        conditions = "#{conditions} and sub_rubro_id =  #{params[:sub_rubro_id][0]} "
        sub_rubro = SubRubro.find(params[:sub_rubro_id][0])
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.sub_rubro_igual')} '#{sub_rubro.nombre}'"
      end
    end

    unless params[:nombre].nil? || params[:nombre].empty?
      if conditions.nil?
        conditions = "LOWER(tasa.nombre) LIKE " << "'%" << params[:nombre].strip.downcase << "%'"
      else
        conditions << " and LOWER(tasa.nombre) LIKE " << "'%" << params[:nombre].strip.downcase << "%'"

      end
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end

    
    @list = Tasa.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end


  def sector_tasa_change
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_tasa_change'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'sub-sector-select'
    end
  end

  def sector_tasa_change_list
    sub_sector_fill(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_tasa_change_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'
      page.show 'sub-sector-select'
    end
  end


  def sub_sector_tasa_change
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'

    end
  end

  def sub_sector_tasa_change_list
    logger.info "sub_sector_id ============> #{params[:sub_sector_id]}"
    rubro_fill(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_tasa_change_list'
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.show 'rubro-select'
      page.show 'sub_rubro-select'

    end
  end

  def rubro_tasa_change
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change'
      page.show 'sub_rubro-select'
    end
  end

  def rubro_tasa_change_list
    sub_rubro_fill(params[:rubro_id])
    render :update do |page|
      page.replace_html 'sub_rubro-select', :partial => 'sub_rubro_tasa_change_list'
      page.show 'sub_rubro-select'
    end
  end

  def new
    @sector_list = Sector.all(:conditions=>'activo = true', :order=>'nombre')
    @sub_sector_list =[]
    @rubro_list =[]
    @sub_rubro_list =[]
    @tasa = Tasa.new
  end

  def save_new
    @tasa = Tasa.new(params[:tasa])
    form_save_new @tasa
  end

  def delete
    @tasa = Tasa.find(params[:id])
    form_delete @tasa
  end

  def edit
    @tasa = Tasa.find(params[:id])
    @sector_list = Sector.all( :conditions=>'activo = true', :order=>'nombre')
    @sub_sector_list = SubSector.all( :conditions=>['sector_id = ? and activo = true', @tasa.sector_id], :order=>'nombre')
    @rubro_list = Rubro.all(:conditions=>['sub_sector_id = ? and activo = true', @tasa.sub_sector_id], :order=>'nombre')
    @sub_rubro_list = SubRubro.all(:conditions=>['rubro_id = ? and activo = true', @tasa.rubro_id], :order=>'nombre')

  end

  def view
    @tasa = Tasa.find(params[:id])
  end

  def save_edit
    @tasa = Tasa.find(params[:id])
    form_save_edit @tasa
  end

  def fill_tipo_cliente
    @tipo_cliente_select = TipoCliente.all(:order=>'nombre')
  end


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Tasa.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Tasa.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Tasa.FormTitles.form_title_records')
    @form_entity = 'tasa'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end

  def sector_fill(sector_id)
    @sector_list = Sector.all(:conditions=>'activo = true', :order=>'nombre')
    if sector_id > 0
        sub_sector_fill(@sector_list[0].id)
    else
      sub_sector_fill(0)
    end
  end

  def sub_sector_fill(sector_id)
    if sector_id.to_i > 0
      @sub_sector_list = SubSector.all( :conditions=>['sector_id = ? and activo = true', sector_id], :order=>'nombre')
      logger.info "sub_sector_list ============> #{@sub_sector_list.inspect}"
      rubro_fill(@sub_sector_list[0].id)
    else
      @sub_sector_list =[]
      rubro_fill(0)
    end
  end

  def rubro_fill(sub_sector_id)
    if sub_sector_id.to_i > 0
        @rubro_list = Rubro.all(:conditions=>['sub_sector_id = ? and activo = true', sub_sector_id], :order=>'nombre')
        logger.info "rubro_list ============> #{@rubro_list.inspect}"
        logger.info "sub_sector_id =========> #{sub_sector_id.to_s}"
        unless @rubro_list.empty?
          sub_rubro_fill(@rubro_list[0].id)
        else
           @sub_rubro_list = []
        end
    else
        @rubro_list =[]
        sub_rubro_fill(0)
    end
  end

  def sub_rubro_fill(rubro_id)
    if rubro_id.to_i > 0
        @sub_rubro_list = SubRubro.all(:conditions=>['rubro_id = ? and activo = true', rubro_id], :order=>'nombre')
    else
        @sub_rubro_list =[]
    end
  end


end
