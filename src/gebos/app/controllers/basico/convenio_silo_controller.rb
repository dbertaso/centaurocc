# encoding: utf-8

class Basico::ConvenioSiloController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:tabs]
  
	def index
    @silo = Silo.find(params[:silo_id])
		list
	end
	
  def list
    params['sort'] = "status" unless params['sort']
    @condition = "silo_id =#{params[:silo_id]}"

    @list = ConvenioSilo.search(@condition, params[:page], params[:sort])
    @total=@list.count
    
    form_list
  end
	
  def new
    @silo = Silo.find(params[:silo_id])
    @ciclo_productivo_list = CicloProductivo.find(:all)
    @convenio_silo = ConvenioSilo.new
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
     params[:convenio_silo][:status] = true
    @convenio_silo = ConvenioSilo.new(params[:convenio_silo])
    @convenio_silo.usuario_id = session[:id]
    @convenio_silo.silo_id = params[:silo_id]
    @convenio_silo.fecha_registro_f = Time.now.strftime("#{I18n.t('time.formats.gebos_short')}")
		form_save_new @convenio_silo
  end
  
  def delete
    @convenio_silo = ConvenioSilo.find(params[:id])
     result = @convenio_silo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @convenio_silo, 'convenio_silo'
      end
    end
  end
  
  def edit
    @convenio_silo = ConvenioSilo.find(params[:id])
    @silo = @convenio_silo.silo
    @ciclo_productivo_list = CicloProductivo.find(:all)
  end

  def save_edit
    @convenio_silo = ConvenioSilo.find(params[:id])
		form_save_edit @convenio_silo
  end

  def cancel_edit
    @convenio_silo = ConvenioSilo.find(params[:id])
		form_cancel_edit @convenio_silo
  end

  def view
    @convenio_silo = ConvenioSilo.find(params[:id])
    @silo = @convenio_silo.silo
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.ConvenioSilo.Header.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.ConvenioSilo.Header.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Vistas.ConvenioSilo.Header.form_title_records')
    @form_entity = 'convenio_silo'
    @form_identity_field = 'numero_memorandum'
    @width_layout = '850'
  end
  
end
