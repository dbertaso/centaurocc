# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::SubRubroController
# descripción: Migración a Rails 3
#
class Basico::SubRubroController < FormTabTabsController

  def index
    @rubro = Rubro.find(params[:rubro_id])
    @sub_sector = SubSector.find(@rubro.sub_sector_id)
    @sector = Sector.find(@sub_sector.sector_id)
    list
  end

  def list
    params['sort'] = "sub_rubro.nombre" unless params['sort']
    @condition = "rubro_id = #{params[:rubro_id]}"
    
    @list = SubRubro.search(@condition, params[:page], params['sort'])
    @total=@list.count

   form_list
  end

  def new
    @rubro = Rubro.find(params[:rubro_id])
    @sub_sector = SubSector.find(@rubro.sub_sector_id)
    @sector = @sub_sector.sector
    @sub_rubro = SubRubro.new
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:sub_rubro][:nombre])
    params[:sub_rubro][:nombre] = nombre.upcase
    @sub_rubro = SubRubro.new(params[:sub_rubro])
    @sub_rubro.rubro_id = params[:rubro_id]
    form_save_new @sub_rubro
  end

#  def delete
#    @sub_sector = SubSector.find(params[:id])
#    form_delete @sub_sector
#  end

    def delete
    @sub_rubro = SubRubro.find(params[:id])
    result = @sub_rubro.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @sub_rubro, 'sub_rubro'
      end
    end
  end

  def edit
    @sub_rubro = SubRubro.find(params[:id])
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end


  def save_edit
    nombre = eliminar_acentos(params[:sub_rubro][:nombre])
    params[:sub_rubro][:nombre] = nombre.upcase
    @sub_rubro = SubRubro.find(params[:id])
    form_save_edit @sub_rubro
  end

  def cancel_edit
    @sub_rubro = SubRubro.find(params[:id])
    form_cancel_edit @sub_rubro
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.SubRubro.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.SubRubro.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.SubRubro.FormTitles.form_title_records')
    @form_entity = 'sub_rubro'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end

end
