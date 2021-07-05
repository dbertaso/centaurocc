# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Basico::InstanciaComiteNacionalController
# descripción: Migración a Rails 3
#


class Basico::InstanciaComiteNacionalController < FormAjaxController

  skip_before_filter :set_charset, :only=>[:delete_miembro,:save_comite,:cancel_form]

  def index
    list
  end

  def list
    params['sort'] = " comite.id desc " unless params['sort']
    @total = ComiteDecisionHistorico.count_by_sql"select count(distinct comite_id) from comite_decision_historico cdh where tipo_comite='n' "
    conditions=" comite_decision_historico.tipo_comite='n' "
    @list = Comite.search(conditions, 
                            params[:page], 
                            params['sort'])
    

    form_list
  end

  def cancel_new
    form_cancel_new
  end

  def new
    @comite = Comite.new
    resp    = @comite.crear_comite_nacional session
    render :update do |page|
      if resp==1
        page.redirect_to :action=>'index'
      else
        error=resp
        page.replace_html "error","<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL><LI>" << error << "</LI>"
        page.show "error"
        page.<< "window.scrollTo(0,0);"
      end
    end
  end

  def cancel_form
    render :update do |page|
      page.redirect_to :action=>'index'
    end
  end

  def delete_miembro
      if (request.xhr?)
        comite_miembro        = ComiteMiembro.find(params[:id])
        comite_id = comite_miembro.comite_id
        total_miembro_comite = ComiteMiembro.count_by_sql("select count(distinct id) from comite_miembro where comite_id=#{comite_id}")
        if !total_miembro_comite.nil? && total_miembro_comite.to_i == 1
          render :update do |page|
            page.alert I18n.t('Sistema.Body.Modelos.Errores.no_puede_eliminar_miembro_del_comite')
          end
          #render :text =>  "1"
        else
          ComiteMiembro.delete(params[:id])
          fill(comite_id)
          render :update do |page|
            page.hide "error"
            page.replace_html "message",I18n.t('Sistema.Body.Vistas.InstanciaComiteNacional.Mensajes.integrante_eliminado_con_exito')
            page.show "message"
            page.<< "window.scrollTo(0,0);"
            page.replace_html 'miembros-select', :partial => 'miembros_select'
            page.replace_html 'list-miembro', :partial => 'list_miembro'
          end
        end
      end
  end

  def edit
    @comite       = Comite.find(params[:id])
    @meridiano=[I18n.t('Sistema.Body.Vistas.General.am'),I18n.t('Sistema.Body.Vistas.General.pm')]
    @tab          = params[:tab].nil? ? "datos_basicos" : params[:tab]
    @rol_comite   = RolComite.find(:all,:order=>"nombre",:conditions=>"activo=true")    
    @punto_cuenta = PuntoCuenta.find(:first,:conditions=>['id = ?', @comite.punto_cuenta_id]) if !@comite.punto_cuenta_id.nil?
    fill(@comite.id)
  end

  ########################
  ##   Guardar Comite   ##
  ########################
  def save_comite
    #resp_comite       = false
    resp_punto_cuenta = false
    @comite = Comite.find(params[:id])
    if !params[:tab_actual].nil?
      if params[:tab_actual]=="datos_basicos"
        params[:comite][:fecha_apertura]= DateTime.strptime(params[:comite][:fecha_apertura],I18n.t('time.formats.gebos_short')).to_time if !params[:comite][:fecha_apertura].nil? && !params[:comite][:fecha_apertura].empty?
        render :update do |page|
          flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.modificando_el_comite_nro')} #{@comite.numero}"
          if @comite.update_attributes(params[:comite])
            page.redirect_to( :action=>'edit', :id=>@comite.id,:tab=> @comite.punto_cuenta_id.nil? ? "punto_cuenta" : "datos_basicos")
          else
            page.form_error
            page.<< "window.scrollTo(0,0);"
          end
        end
      end

      if params[:tab_actual]=="punto_cuenta"
        punto_cuenta_id = @comite.punto_cuenta_id
        if punto_cuenta_id.nil?
          @punto_cuenta = PuntoCuenta.new(params[:punto_cuenta])
          resp_punto_cuenta = @punto_cuenta.save
          punto_cuenta_id   = @punto_cuenta.id
        else
          @punto_cuenta=PuntoCuenta.find_by_id(punto_cuenta_id.to_i)
          resp_punto_cuenta = @punto_cuenta.update_attributes(params[:punto_cuenta])
        end
        render :update do |page|
          if resp_punto_cuenta
            #@comite.vigente=false #update_attribute("vigente",false)
            #@comite.punto_cuenta_id=punto_cuenta_id
            #@comite.save
            @comite.update_attribute("vigente",false)
            @comite.update_attribute("punto_cuenta_id",punto_cuenta_id)
            flash[:notice] = "#{I18n.t('Sistema.Body.Modelos.General.modificando_el_comite_nro')} #{@comite.numero}"
            page.redirect_to( :action=>'edit', :id=>@comite.id,:tab=>"punto_cuenta")
          else
            page.form_error
            page.<< "window.scrollTo(0,0);"
          end
        end
      end
    end
  end

  def cancel_edit
    @comite = Comite.find(params[:id])
    form_cancel_edit @comite
  end
#
#  def view
#    @comite = Comite.find(params[:id])
#    fill(@comite.id)
#    render :update do |page|
#      page.form_reset
#      page.hide "row_#{@comite.id}"
#      page.insert_html :after, "row_#{@comite.id}", :partial => 'view'
#      page.show "row_#{@comite.id}_view"
#    end
#  end
#

  def view
    @comite = Comite.find(params[:id])
    @meridiano=[I18n.t('Sistema.Body.Vistas.General.am'),I18n.t('Sistema.Body.Vistas.General.pm')]
    fill(@comite.id)
    @comite       = Comite.find(params[:id])
    @tab          = params[:tab].nil? ? "datos_basicos" : params[:tab]
    @rol_comite   = RolComite.find(:all,:order=>"nombre",:conditions=>"activo=true")
    @punto_cuenta = PuntoCuenta.find(:first,:conditions=>['id = ?', @comite.punto_cuenta_id]) if !@comite.punto_cuenta_id.nil?
    fill(@comite.id)
  end

  def cancel_view
    comite_id = params[:id]
    render :update do |page|
      page.form_reset
      page.remove "row_#{comite_id}_view"
      page.show "row_#{comite_id}"
    end
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.FormTitles.form_title_nacional')
    @form_title_record  = I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.FormTitles.form_title_record')
    @form_title_records  = I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.FormTitles.form_title_records')
    @width_layout        = 1000
    @records_by_page = 25
  end

  private
  def fill(comite_id)
    @miembro_comite_select = MiembroComite.find(:all,:order => 'nombre', :conditions=>"miembro_comite.id not in (select miembro_comite_id from comite_miembro where comite_id = #{comite_id})")
    sql="select cm.id, m.cedula, m.nombre as nombre_comite, m.apellido as apellido_comite,cm.firma ,r.nombre as rol_nombre
      from miembro_comite m, comite_miembro cm, rol_comite r
      where cm.comite_id = #{comite_id} and cm.miembro_comite_id = m.id and cm.rol_comite_id=r.id"
    @list_miembro=Comite.find_by_sql(sql)
  end
end
