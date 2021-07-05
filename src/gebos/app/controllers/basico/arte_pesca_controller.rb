# encoding: UTF-8

#
# autor: Luis Rojas
# clase: Basico::ArtePescaController
# descripción: Migración a Rails 3
#
class Basico::ArtePescaController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:tipo_arte_pesca_change]

	def index
		fill_arte_pesca
		@visitas = SeguimientoVisita.find(params[:id])
    @solicitud = Solicitud.find(@visitas.solicitud_id)
    
    #@visitas = SeguimientoVisita.find(params[:id])
    list
	end

  def list

    if params[:id_de_embarcacion].to_s==''
      id_de_embarcacion=0
    else
      id_de_embarcacion=params[:id_de_embarcacion]
    end

    @visita = params[:id]
    @id_embarcacion=params[:id_embarcacion]
    @arte_pesca = ArtePesca.find_by_seguimiento_visita_id(params[:id])
    params['sort'] = "nombre_arte_pesca" unless params['sort']
    
    @condition = "seguimiento_visita_id = #{params[:id]} and embarcacion_id = #{id_de_embarcacion}"    
    @list = ArtePesca.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list

  end

  def actualizo
    @contenido=params[:arte_pesca_index]
    fill_arte_pesca
    
    render :partial => 'new',:arte_pesca_index=>params[:arte_pesca_index], :id=> params[:id], :popup=>params[:popup]
  
  end
  
  
  def tipo_arte_pesca_change
    @tipo_arte_especial=params[:id]

    @tipo_arte_pesca=TipoArtePesca.find(:all,:order=>'tipo',:conditions => ['grupo = ?', @tipo_arte_especial])

    render :update do |page|
      page.replace_html 'tipo-mensaje', :partial => 'mensaje'
    end
  
  end

  def check_new
    
	  if params[:arte_pesca_index].to_i > 0
      logger.debug "Aqui me quede =====> " << params[:arte_pesca_index].to_i
      #logger.info "Entre aqui"
      @contenido=params[:arte_pesca_index]
      logger.debug "Entre aqui2 " << params[:arte_pesca_index]

      render :partial => 'new',:id_arte_pesca=>params[:arte_pesca_index], :id=> params[:id], :popup=>params[:popup]
    else
      render :update do |page|
        page.alert "Debe introducir un arte de pesca"
      end
    end
  end

  def new

    @contenido = params[:arte_pesca_index].to_i
    @visita = params[:id]
    fill_arte_pesca
    @tipo_arte_pesca=[]
    @ar1=0
    @arte_pesca = ArtePesca.new
	form_new @arte_pesca    
  end

  
  
  
  def cancel_new
		form_cancel_new
  end

  def save_new

    @visita = params[:id]
    #@id_embarcacion = params[:id_embarcacion]
    logger.info "los parametroe en el save new " << params[:arte_pesca][:tipo_arte_pesca_id]
    @arte_pesca = ArtePesca.new(params[:arte_pesca])
    @arte_pesca.nombre_arte_pesca = TipoArtePesca.find(params[:arte_pesca][:tipo_arte_pesca_id]).tipo unless (params[:arte_pesca][:tipo_arte_pesca_id]) == ''
    @arte_pesca.seguimiento_visita_id = @visita
    @id_mo=@arte_pesca.embarcacion_id
    form_save_new @arte_pesca

  
  end

  def delete
    @arte_pesca = ArtePesca.find(params[:id])
	#form_ajaxdelete @arte_pesca
    form_delete @arte_pesca
  end

  def edit
    fill_arte_pesca

    @arte_pesca = ArtePesca.find(params[:id_pesca_index])
    #@item = Item.find(params[:id_arte_pesca])
    logger.debug "ARTE PEEEE " << @arte_pesca.tipo_arte_pesca.grupo.strip.upcase
    case @arte_pesca.tipo_arte_pesca.grupo.strip.upcase
    when "REDES"
      @contenido=1
      @guardo=@arte_pesca.tipo_arte_pesca.tipo.strip.upcase
    when "PALANGRES"
      @contenido=2
      @guardo=@arte_pesca.tipo_arte_pesca.tipo.strip.upcase
    when "NASAS"
      @contenido=3
      @guardo=@arte_pesca.tipo_arte_pesca.tipo.strip.upcase
    when "CORDELES"
      @contenido=4
      @guardo=@arte_pesca.tipo_arte_pesca.tipo.strip.upcase
    else
      @contenido=5
      @guardo=@arte_pesca.tipo_arte_pesca.tipo.strip.upcase
    end
    
    @tipo_arte_pesca=TipoArtePesca.find(:all,:order=>'tipo',:conditions => ['grupo = ?', @arte_pesca.tipo_arte_pesca.grupo])

    
    @es_algo=1
    @identificador_embarcacion=@arte_pesca.embarcacion_id
		
		if @arte_pesca.condicion != "***No-aplica***" && @arte_pesca.condicion != nil
      @ar1=1
    else
      @ar1=0
    end
		
		form_edit @arte_pesca
  end

  def save_edit
    @arte_pesca = ArtePesca.find(params[:id_pesca_index])
    @id_mo=@arte_pesca.embarcacion_id
    @id_seg=@arte_pesca.seguimiento_visita_id 
   
    form_save_edit @arte_pesca
  end

  def cancel_edit
    @arte_pesca = ArtePesca.find(params[:id])
		form_cancel_edit @arte_pesca
  end


  def view
    @arte_pesca = ArtePesca.find(params[:id_pesca_index])
    form_view @arte_pesca

  end


  def fill_arte_pesca
    
    if params[:id].nil?
      @mot = ArtePesca.find(params[:id_pesca_index])
      @iii=@mot.seguimiento_visita_id
    else
      @iii=params[:id]
    end
        
    @solicitud_id = SeguimientoVisita.find(@iii.to_s)
    @identificador_rubro = Solicitud.find(@solicitud_id.solicitud_id.to_s)    
    @item_pesca=TipoArtePesca.find_by_sql("select distinct(grupo) from tipo_arte_pesca order by grupo")
    @embarcaciones=Embarcacion.find(:all, :conditions=>"solicitud_id = #{@solicitud_id.solicitud_id}", :order=>'nombre_embarcacion')
    @proveedor_marino=ProveedorMarino.find(:all,:order=>'nombre')
    @tipo_nylon=TipoNylon.find(:all,:order=>'tipo')


  end

  protected
  def common
    super
    @form_title = 'Artes de Pesca'
    @form_title_record = 'Arte de Pesca'
    @form_title_records = 'Artes de Pesca'
    @form_entity = 'arte_pesca'
    @form_identity_field = 'nombre_arte_pesca'
    @width_layout = '955'
  end
  
end
