# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::GarantiaSector
# descripción: Migración a Rails 3
#

class Basico::GarantiaSectorController < FormAjaxController

  skip_before_filter :set_charset, :only=>[:sector_change]
  def index
    list
  end
  
  def list

    params['sort'] = "sub_sector_id" unless params['sort']

    
    @list = GarantiaSector.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list
  end
  
  def new
    @garantia_sector = GarantiaSector.new
    fill
    form_new @garantia_sector
  end

  def fill
    @tipo_garantia_list = TipoGarantia.find(:all, :order=>'nombre')
    @sector_list = Sector.find(:all, :order=>'nombre')
    unless @garantia_sector.id.nil?
      if @garantia_sector.sub_sector.sector_id
        sector_id = @garantia_sector.sub_sector.sector_id
      else
        sector_id = @sector_list[0].id
      end
    else
      sector_id = @sector_list[0].id
    end
    @sub_sector_list = SubSector.find(:all, :conditions=>['sector_id = ?', sector_id], :order=>'nombre')
  end

  def sector_change
    logger.info 'parametros =====> ' << params.inspect
    @sub_sector_list = SubSector.find(:all, :conditions=>"sector_id = #{params[:sector_id]}")
    logger.info 'Sub_sector List =========> ' << @sub_sector_list.inspect
    render :update do |page|
      page.replace_html 'sub_sector-search', :partial => 'sub_sector_search'
    end
  end

  def cancel_new
    form_cancel_new
  end
  
  def save_new
    @garantia_sector = GarantiaSector.new(params[:garantia_sector])
    form_save_new @garantia_sector
  end

  # # OJOOO COLOCAR METODO COMO EL DE SECTOR... QUE VERIFIQUE QUE NO HAY REGISTROS RELACIONADOS.
  def delete
    @garantia_sector = GarantiaSector.find(params[:id])
    form_delete @garantia_sector
  end
  
  def edit
    @garantia_sector = GarantiaSector.find(params[:id])
    @solicitud = Solicitud.new
    @solicitud.sector_id = @garantia_sector.sub_sector.sector_id
    fill
    form_edit @garantia_sector
  end
  
  def save_edit
    @garantia_sector = GarantiaSector.find(params[:id])
    form_save_edit @garantia_sector
  end
  
  def cancel_edit
    @garantia_sector = GarantiaSector.find(params[:id])
    form_cancel_edit @garantia_sector
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.GarantiaSector.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.GarantiaSector.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.GarantiaSector.FormTitles.form_title_record')
    @form_entity = 'garantia_sector'
    @form_identity_field = 'garantia'
  end
  
end
