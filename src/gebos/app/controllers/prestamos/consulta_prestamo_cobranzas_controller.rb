
class Prestamos::ConsultaPrestamoCobranzasController < FormTabsController

  layout 'form_basic'

  def index

    @prestamo = Prestamo.find(params[:prestamo_id])
    @cliente = @prestamo.cliente
  end


  def view

    @prestamo = Prestamo.find(params[:id])

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoCobranzas.FormTitles.form_title')
    @form_entity = 'prestamo'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end

end


