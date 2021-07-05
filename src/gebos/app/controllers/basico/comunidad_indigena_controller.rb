# encoding: utf-8
class Basico::ComunidadIndigenaController < FormAjaxController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :municipio_change]

	def index
		list
	end
	
  def list
    params['sort'] = "id" unless params['sort']
    conditions = "id > 0"
    
    @list = ComunidadIndigena.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @comunidad_indigena = ComunidadIndigena.new
    fill
		form_new @comunidad_indigena
  end

def fill
    @estado_list = Estado.find(:all, :order=>'nombre')
    unless @comunidad_indigena.id.nil?
      if @comunidad_indigena.estado_id
        estado_id = @comunidad_indigena.estado_id
      else
        estado_id = @estado_list[0].id
      end
    else
      estado_id = nil
    end
    municipio_fill(estado_id)
  end

  def municipio_fill(estado_id)
    if estado_id.nil?
      @municipio_list = []
    else
      @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
      unless @comunidad_indigena.municipio_id.nil?
        municipio_id = @comunidad_indigena.municipio_id
      else
        municipio_id = nil
      end
    end
    parroquia_fill(municipio_id)
  end

  def parroquia_fill(municipio_id)
    if municipio_id.nil?
      @parroquia_list = []
    else
        unless @comunidad_indigena.id.nil?
          @parroquia_list = Parroquia.find(:all, :conditions=>['municipio_id = ?', municipio_id], :order=>'nombre')
        else
          @parroquia_list = []
        end
    end
  end

  def estado_change
    unless params[:estado_id].blank?
      @municipio_list = Municipio.find(:all, :conditions=>"estado_id = #{params[:estado_id]}")
    else
      @municipio_list = []
    end
    @parroquia_list = []
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end
  
  def municipio_change
    unless params[:municipio_id].blank?
      @parroquia_list = Parroquia.find(:all, :conditions=>"municipio_id = #{params[:municipio_id]}")
    else
      @parroquia_list = []
    end
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @comunidad_indigena = ComunidadIndigena.new(params[:comunidad_indigena])
    comunidad_indigena = @comunidad_indigena.eliminar_acentos(params[:comunidad_indigena][:comunidad_indigena])
    @comunidad_indigena.comunidad_indigena = comunidad_indigena.upcase
    pueblo_indigena = @comunidad_indigena.eliminar_acentos(params[:comunidad_indigena][:pueblo_indigena])
    @comunidad_indigena.pueblo_indigena = pueblo_indigena.upcase
		form_save_new @comunidad_indigena
  end

  def delete
    @comunidad_indigena = ComunidadIndigena.find(params[:id])
		form_delete @comunidad_indigena
  end
  
  def edit
    @comunidad_indigena = ComunidadIndigena.find(params[:id])
    fill
		form_edit @comunidad_indigena
  end
  
  def save_edit
    @comunidad_indigena = ComunidadIndigena.find(params[:id])
		form_save_edit @comunidad_indigena
  end
  
  def cancel_edit
    @comunidad_indigena = ComunidadIndigena.find(params[:id])
		form_cancel_edit @comunidad_indigena
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.ComunidadIndigena.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.ComunidadIndigena.Header.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ComunidadIndigena.Header.form_title')
    @form_entity = 'comunidad_indigena'
    @form_identity_field = 'comunidad_indigena'
  end
  
end
