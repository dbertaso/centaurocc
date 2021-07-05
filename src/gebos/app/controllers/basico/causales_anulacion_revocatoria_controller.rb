# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Basico::CausalesAnulacionRevocatoriaController
# descripción: Migración a Rails 3
#

class Basico::CausalesAnulacionRevocatoriaController < FormAjaxController

    def index
		  list
	  end
	
      def list

        params['sort'] = "causales_anulacion_revocatoria.causa" unless params['sort']

        @list = CausalesAnulacionRevocatoria.search('', params[:page], params['sort'])    
        @total=@list.count        
        form_list
      end
        
      def new
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.new
        form_new @causales_anulacion_revocatoria
      end
      
      def cancel_new
        form_cancel_new
      end
      
      def save_new
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.new(params[:causales_anulacion_revocatoria])
        form_save_new @causales_anulacion_revocatoria
      end
      
      def delete
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.find(params[:id])
        form_delete @causales_anulacion_revocatoria
      end
      
      def edit
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.find(params[:id])
        form_edit @causales_anulacion_revocatoria
      end
      def save_edit
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.find(params[:id])
        form_save_edit @causales_anulacion_revocatoria
      end
      def cancel_edit
        @causales_anulacion_revocatoria = CausalesAnulacionRevocatoria.find(params[:id])
        form_cancel_edit @causales_anulacion_revocatoria
      end
      
      protected
      def common
        super
        @form_title = I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Header.form_title')
        @form_title_record = I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Header.form_title_record')
        @form_title_records = I18n.t('Sistema.Body.Vistas.CausalesAnulacionRevocatoria.Header.form_title_records')
        @form_entity = 'causales_anulacion_revocatoria'
        @form_identity_field = 'causa'
      end
  
end
