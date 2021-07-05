
# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Gestion::IndicadorGlobalController
# descripción: Migración a Rails 3
#

class Gestion::IndicadorGlobalController < FormTabsController

  layout 'form_basic'

  def index

	  monto_anio = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ?", Date.today, Date.new(Date.today.year, 12, 31)])
    meta_anio = 0
    @icvencidos = 0.00
    @icvigentes = 0.00
    cantidad_total = 0.00
    vencido_cantidad = 0.00
    @IM = 0
    @iv = 0
    @cl = 0
    @cv = 0
    @rf = 0
    @ra = 0
    # if (meta = Meta.find_by_anio(Date.today.year)) 
    #  meta_anio = meta.monto_liquidado

    
    #--------------------------------------------------------------------------------
    #Diego Bertaso
    #Se agrego el estatus de vencido en la gracia de la mora ya que no se estaba
    #tomado en cuenta. Se cambio la deuda por el capital_vencido en las totalizaciones
    #de monto
    #--------------------------------------------------------------------------------
    # 
   	cantidad_total = Prestamo.count('id', :conditions=>"estatus='V' or estatus='E' or estatus='P'")
   	cantidad_vigente = Prestamo.count('id', :conditions=>"estatus='V'")
   	vencido_monto = Prestamo.sum('capital_vencido', :conditions=>"estatus='E' or estatus='P'")
   	vencido_cantidad = Prestamo.count('numero', :conditions=>"estatus='E' or estatus='P'")
   	#---> fin de modificacion
   	
   	litigio_monto = Prestamo.sum('saldo_insoluto', :conditions=>"estatus='L'")
   	cartera_bruta = Prestamo.sum('saldo_insoluto', :conditions=>"estatus='V' or estatus='E' or estatus='P' ")
   	vigente_monto = Prestamo.sum('saldo_insoluto', :conditions=>"estatus='V'")
   	saldo_vencido = Prestamo.sum('saldo_insoluto', :conditions=>"estatus='E' or estatus='P'")
   	reestructurado_monto_fin = Prestamo.sum('saldo_insoluto', :conditions=>"reestructurado='F'")
   	reestructurado_monto_adm = Prestamo.sum('saldo_insoluto', :conditions=>"reestructurado='A'")
    vigente_monto_anio = Prestamo.sum('capital_vencido', :conditions=>["estatus='V' and extract(year from fecha_liquidacion) = ?", Date.today.year])
    
    vigente_monto = 0 unless !vigente_monto.nil?
    vigente_monto_anio = 0 unless !vigente_monto_anio.nil?
    litigio_monto = 0 unless !litigio_monto.nil?
    vencido_monto = 0 unless !vencido_monto.nil?
    
    #-------------------------------------------------------------------------------------------------------
    #Diego Bertaso
    #Se cambio la formula de intermediacion financiera por indice de prestamos vencidos
    #-------------------------------------------------------------------------------------------------------
    #
    
    @icvencidos= (cantidad_total!=nil && cantidad_total!=0 && vencido_cantidad!=nil) ? vencido_cantidad.to_f / cantidad_total.to_f : 0
    @icvencidos = @icvencidos * 100
    
    @icvigentes= (cantidad_total!=nil && cantidad_total!=0 && cantidad_vigente!=nil) ? cantidad_vigente.to_f / cantidad_total.to_f : 0
    @icvigentes = @icvigentes * 100
    
    #@ICV = cantidad_total
    #---> fin modificacioneso
    
    @im = (cartera_bruta!=nil && cartera_bruta!=0 && vencido_monto!=nil) ? vencido_monto / cartera_bruta : 0
    @im = @im * 100
    
    @iv = (cartera_bruta!=nil && cartera_bruta!=0 && vigente_monto!=nil) ? vigente_monto / cartera_bruta : 0
    @iv = @iv * 100
  
    @cv = (cartera_bruta!=nil && cartera_bruta!=0 && saldo_vencido!=nil) ? saldo_vencido / cartera_bruta : 0
    @cv = @cv * 100
    
    @cl = (cartera_bruta!=nil && cartera_bruta!=0 && reestructurado_monto_fin!=nil) ? reestructurado_monto_fin / cartera_bruta : 0
    @cl = @cl * 100

    @rf = (cartera_bruta!=nil && cartera_bruta!=0 && litigio_monto!=nil) ? litigio_monto / cartera_bruta : 0
    @rf = @rf * 100
    
    @ra = (cartera_bruta!=nil && cartera_bruta!=0 && reestructurado_monto_adm!=nil) ? reestructurado_monto_adm / cartera_bruta : 0
    @ra = @ra * 100

  end
    
  protected  
  def commonm
    super
    @form_title = I18n.t('Sistema.Body.Controladores.IndicadorGlobal.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.IndicadorGlobal.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.IndicadorGlobal.FormTitles.form_title_records')
    @form_entity = ''
    @form_identity_field = ''
    @width_layout = 900;
  end

end

