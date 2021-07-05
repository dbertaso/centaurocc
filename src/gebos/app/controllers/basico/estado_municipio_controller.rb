# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::EstadoCiudadController
# descripción: Migración a Rails 3
#


class Basico::EstadoMunicipioController < FormTabTabsController

  #skip_before_filter :set_charset, :only=>[:form_save_edit]

  def index
    list
  end

  def list
    #_list
    @estado = Estado.find(params[:estado_id])
    conditions = ["municipio.estado_id = ?", @estado.id]
    params['sort'] = "nombre" unless params['sort']
    

    @list = Municipio.search(conditions,
                            params[:page],
                            params['sort'])
    @total=@list.count

    form_list

  end

  def new
    @estado = Estado.find(params[:estado_id])
    @municipio = Municipio.new
    fill_eje

  end

  def view
    list_view
  end

  def list_view
    #_list
    form_list_view
  end

  def save_new
    @municipio = Municipio.new(params[:municipio])
    @municipio.estado = @estado
    form_save_new @municipio
  end

  def edit
    @municipio = Municipio.find(params[:id])
    fill_eje
  end
  def save_edit

    @municipio = Municipio.find(params[:id])
    form_save_edit(@municipio)
  end



 def form_save_new(entity, options={})

    logger.debug "entre por aqui 444"

    value = options[:value]
    if value.nil?
      value = entity.save
    end
    #logger.info entity.inspect
    #logger.info entity.errors.size

    if value
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.insercion')}"
      render :update do |page|
      new_options = {:action=>'index', :estado_id => @estado.id, :id=>entity.id }
      new_options.merge!(options[:params]) unless options[:params].nil?
      new_options.merge!({:popup=>params[:popup]}) unless params[:popup].nil?
      logger.debug "opciones " << new_options.to_s
      page.redirect_to new_options
      end
    else
      render :update do |page|
      page.form_error
      page.<< "window.scrollTo(0,0);"
        end
    end
  end




 def form_save_edit(entity, options={})
    value = options[:value]
    if value.nil?
      value = entity.update_attributes(params[@form_entity])
    end
    if value
      identity_field = entity_field(entity, @form_identity_field)
      flash[:notice] = "#{@form_title_record} '#{identity_field}' #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      render :update do |page|
        if !params[:controlador].nil?
          new_options = {:controlador => params[:controlador], :action=>'edit', :estado_id => @estado.id, :id=>entity.id }
        else
          new_options = {:action=>'edit', :estado_id => @estado.id, :id=>entity.id }
        end
        new_options.merge!(options[:params]) unless options[:params].nil?
        new_options.merge!({:popup=>params[:popup]}) unless params[:popup].nil?
        page.redirect_to new_options
      end
    else
      render :update do |page|
        page.form_error
        page.<< "window.scrollTo(0,0);"
      end
    end
  end


  def cancel_edit
    @municipio = Municipio.find(params[:id])
    form_cancel_edit @municipio
  end

  def cancel_new
    new_option = {:action=>'index', :estado_id => params[:estado_id] }
       render :update do |page|
        page.redirect_to new_option
       end
  end

  def delete
    @municipio = Municipio.find(params[:id])
    form_delete @municipio
  end

  

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Estado.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.municipio')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.municipios')
    @form_entity = 'municipio'
    @form_identity_field = 'nombre'

    @estado = Estado.find(params[:estado_id])

  end

  def protect
    action = super
    return action unless action.nil?
    case action_name
    when 'list'
      nil
    when /^_/
      'edit'
    end
  end

  private
  def fill_eje
    @eje_list = Eje.find(:all)
  end

end

