# encoding: utf-8

#
# autor:
# clase: Basico::ProgramaMisionController
# descripción: Migración a Rails 3
#
class Basico::ProgramaMisionController < FormAjaxTabsController

  def index
    list
  end
  def list
    _list

    form_list

  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end

  def new
    @programa = Programa.find(params[:programa_id])    
    @mision = Mision.new
    fill_mision
		form_new @mision
  end
  
  def save_new
    @programa = Programa.find(params[:programa_id])
    @mision = Mision.find(params[:mision][:id])
    form_save_new @mision, :value=>@programa.add_mision(@mision)
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @programa = Programa.find(params[:programa_id])
    @mision = Mision.find(params[:id])
    form_delete @mision, @programa.misiones.delete(@mision)
  end
  
  protected
  def common
    super
    @form_title = 'Programas'
    @form_title_record = 'Misión' 
    @form_title_records = 'Misiones'
    @form_entity = 'mision'
    @form_identity_field = 'nombre'
    @width_layout = 850
  end
  
  private  
  def fill_mision
    @mision_select = Mision.find(:all, :order=>'nombre',   
      :conditions=>"activo = true and ( mision.id not in (select mision_id from programa_mision where programa_id = #{@programa.id} ) )")    
  end
  def _list
    @programa = Programa.find(params[:programa_id])
    conditions = ["programa_mision.programa_id = ?", @programa.id]
    joins = 'INNER JOIN programa_mision ON programa_mision.mision_id = mision.id'
    @params['sort'] = "mision.nombre" unless @params['sort']
    #@total = Mision.count(:conditions=>conditions, :joins=>joins)
    #@pages, @list = paginate(:mision, :class_name => 'Mision',
     #:conditions => conditions,
     #:per_page => @records_by_page,
     #:joins => joins,
     #:select=>'mision.*',
     #:order_by => @params['sort'])
     @list = Mision.search(conditions, params[:page], params[:sort])
     @total=@list.count

  end
end
