# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:check_new]

  layout 'form_basic'

  def list

    params[:sort] = "nombre" unless params[:sort]    
    conditions = 'id > 0'
    unless params[:rif].nil? || params[:rif].empty?
      conditions << " AND LOWER(rif) = '#{params[:rif].strip.downcase}'"
      @form_search_expression << "Rif contenga '#{params[:rif]}'"
    end
    unless params[:alias].nil? || params[:alias].empty?
      conditions << " AND LOWER(alias) LIKE '%#{params[:alias].strip.downcase}%'"
      @form_search_expression << "Nombre Corto contenga '#{params[:alias]}'"
    end
    unless params[:nombre].nil? || params[:nombre].empty?
      conditions << " AND LOWER(nombre) LIKE '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "Nombre contenga '#{params[:nombre]}'"
    end

    
    @list = Empresa.search(conditions, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def check_new
    if params[:rif_1][0].blank? || params[:rif_2].blank? || params[:rif_3].blank?
      render :update do |page|
        page.alert "Debe introducir un rif"
      end
      return
    else
      rif = params[:rif_1][0] + '-' + params[:rif_2] + '-' + params[:rif_3]
      if rif[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/].blank?
        render :update do |page|
          page.alert I18n.t('Sistema.Body.Modelos.Empresa.Errores.rif_no_valido')
        end
        return
      end
      a = rifSeniat(params[:rif_1][0], params[:rif_2], params[:rif_3])
      unless a.blank?
        render :update do |page|
          page.alert a
        end
        return false
      end
    
      cliente = ClienteEmpresa.find(:all, :conditions=>['empresa.rif = ?', rif], :include=>'empresa')
      #empresa = Empresa.find_by_rif(rif)
      if !cliente.nil? && !cliente.empty?
        render :update do |page|
          page.alert "El cliente con el rif  #{rif} ya existe"
        end
      else
        render :update do |page|
          page.redirect_to :action=>'new', :rif=>rif, :popup=>params[:popup]
        end
      end
    end
  end

  def new
    @cliente_empresa = ClienteEmpresa.new
    empresa = Empresa.find_by_rif(params[:rif])
    if empresa
      @empresa = Empresa.find(empresa.id)
    else
      @empresa = Empresa.new(:rif=>params[:rif])
    end
    fill
    @tipo_empresa_id = 1
    @accion = 'new'
  end

  def save_new
    if params[:id] && !params[:id].empty?
      @empresa = Empresa.find(params[:id])
      @cliente_empresa = ClienteEmpresa.find(@empresa.cliente_id)
    else
      @empresa = Empresa.new(params[:empresa])
      @cliente_empresa = ClienteEmpresa.new(params[:cliente_empresa])
    end
    @empresa.cliente_empresa = @cliente_empresa
    @empresa.rif = params[:empresa][:rif_1] + '-' + params[:empresa][:rif_2] + '-' + params[:empresa][:rif_3]
    @empresa.save_new(params[:cliente_empresa][:tipo_cliente_id])
    value = true
    if @empresa.errors.count > 0
      value = false
    end
    form_save_new @empresa, :value=>value
  end

  def edit
    @empresa = Empresa.find(params[:id])
    @cliente_empresa = @empresa.cliente_empresa
    fill
    sector_economico_id = @empresa.sector_economico_id
    actividad_economica_id = @empresa.actividad_economica_id
    entidad_financiera_id = @cliente_empresa.entidad_financiera_id

    actividad_economica_fill(sector_economico_id)
    @accion = 'edit'

    @tipo_empresa_id = @empresa.tipo_empresa_id
    clasificacion_fill
  end

  def save_edit
    @parametros = params[:empresa]
    @cliente = Cliente.find_by_nro_expediente(params[:nro_expediente])

    @empresa = Empresa.find(params[:id])
    #@empresa.rif = params[:rif]
    @cliente_empresa = @empresa.cliente_empresa
    form_save_edit @empresa, :value=>@empresa.update_all(params[:empresa], params[:cliente_empresa])
  end

  def view
    @empresa = Empresa.find(params[:id])
    #@clasificacion = Clasificacion.find_by_id(@empresa.clasificacion_id)
    @sector_economico = SectorEconomico.find_by_id(@empresa.sector_economico_id)
    @actividad_economica = ActividadEconomica.find_by_id(@empresa.actividad_economica_id)
  end

  def clasificacion_change
    @tipo_empresa_id = params[:tipo_empresa_id]
    clasificacion_fill
    render :update do |page|
      page.replace_html 'clasificacion-select', :partial => 'clasificacion_select'
    end
  end

  def sector_economico_change
    sector_economico_id = params[:sector_economico_id]
    actividad_economica_fill(sector_economico_id)
    render :update do |page|
      page.replace_html 'actividad_economica-select', :partial => 'actividad_economica_select'
    end
  end

  def printer
    @empresa = Empresa.find(params[:id])
    @cliente = Cliente.find(:first, :conditions=>['empresa_id = ?', @empresa.id])
    @empresa_direccion = EmpresaDireccion.find(:first, :conditions=>['empresa_id = ?', @empresa.id])
    @persona = Persona.find(params[:id] )
    @empresa_integrantre = EmpresaIntegrante.find(:all, :conditions=>['empresa_id = ?', @empresa.id])
    @empresa_integrantre_tipo = EmpresaIntegranteTipo.find(:all, :conditions=>['empresa_integrante_id = ?', @empresa_integrantre.id])
    @UnidadProduccion = UnidadProduccion.find(:first, :conditions=>['cliente_id = ?', @cliente.id])
    @CuentaBancaria = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?', @cliente.id])
    @empresa_telefono = EmpresaTelefono.find(:all,:conditions=>['empresa_id = ?', @empresa.id] )
   

    render  :layout => 'form_reporte'
  end

  protected
  def common
    super
    @form_title =  "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_records = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_entity = 'empresa'
    @form_identity_field = 'alias'    
    @width_layout = '1100'
  end

  def rifSeniat(rif1, rif2, rif3)
    if rif1 == 'V' || rif1 == "J" || rif1 == 'E' || rif1 == 'P' || rif1 == 'G'
      rif8 = ""
      if rif1 == 'V'
        rif8 = "1" << rif2
      end
      if rif1 == "E"
        rif8 = "2" << rif2
      end
      if rif1 == "J"
        rif8 = "3" << rif2
      end
      if rif1 == "P"
        rif8 = "4" << rif2
      end
      if rif1 == "G"
        rif8 = "5" << rif2
      end

      suma = (rif8[8,1].to_i * 2) + (rif8[7,1].to_i * 3) + (rif8[6,1].to_i * 4) + (rif8[5,1].to_i * 5) +
        (rif8[4,1].to_i * 6) + (rif8[3,1].to_i * 7) + (rif8[2,1].to_i * 2) + (rif8[1,1].to_i * 3)  +
        (rif8[0,1].to_i * 4)

      division = suma / 11

      resto = suma - (division.to_i * 11)
      digito = 0

      if resto > 0
        digito = 11 - resto
      else
        digito
      end
      if digito == 10
        digito = 0
      end
      if digito != rif3.to_i
        return I18n.t('Sistema.Body.Modelos.Errores.rif_invalido')
      else
        return nil
      end
    else
      return I18n.t('Sistema.Body.Modelos.Errores.rif_invalido')
    end
  end


  private
  def fill
    @tipo_empresa_list = TipoCliente.find(:all, :conditions=>'activo=true and clasificacion =\'J\'',:order=>'id')
    @sector_economico_select = SectorEconomico.find(:all, :conditions=>'activo = true and id <> 1000',:order=>'descripcion')
  end

  def clasificacion_fill
    if @tipo_empresa_id.to_s == '1'
      @clasificacion_select = Clasificacion.find(:all, :order=>'descripcion')
    end
  end

  def actividad_economica_fill(sector_economico_id)
    if sector_economico_id.to_i != 0
      @actividad_economica_select = ActividadEconomica.find(:all,:conditions=>'sector_economico_id = ' +
          sector_economico_id.to_s, :order=>'descripcion')
    else
      @actividad_economica_select = ActividadEconomica.find(:all, :order=>'descripcion')
    end
  end

  #  def actividad_economica_fill(sector_economico_id)
  #      @actividad_economica_select = ActividadEconomica.find(:all,:conditions=>'sector_economico_id = ' + sector_economico_id.to_s, :order=>'descripcion')
  #  end

end
