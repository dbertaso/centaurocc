// ------------------------------------------------------------------------------------------
// Funcion generica.
// Selecciona todos los checkbox de la lista y agrega los ids a un campo oculto.
// form_container_id:id del form que contiene los checkboxs,this_:checkbox seleccionado,field:id del campo oculto donde se almacenan los valores.
function checkbox_select_all(form_container_id,this_,field){    
    $(field).value = '';
    var temp       = '';    
    var elements = $(form_container_id).getInputs('checkbox');    
    elements.each(function(item){
        if(!item.disabled) {
            item.checked=this_.checked;
            if(this_.checked) temp += item.value+',';
        }
    });
    $(field).value = temp.replace(/^,+/,'').replace(/,+$/,'');
}
// ------------------------------------------------------------------------------------------
// Selecciona un checkbox y agrega el id seleccionado a un campo oculto
// this_ : checkbox seleccionado, field : id del campo oculto donde se almacenan los valores.
function checkbox_select(this_,field){
    if(this_.checked) {
        var temp       = $(field).value;
        temp          += ','+ this_.value;
        $(field).value = temp.replace(/^,+/,'').replace(/,+$/,'');
    }
    else{        
        var array_solicitud = $(field).value.split(",");
        array_solicitud     = array_solicitud.without(""," ",this_.value);
        $(field).value      = array_solicitud.toArray();
    }
}
// Funciones de comite estadal
function enviar_decision_comite(tipo_comite,mensaje,mensaje2){
    var radio_checked = false;
    var comite=tipo_comite=="e" ? "comite_estadal" : "comite_nacional";
    var elements=$('form_decision_comite').getInputs('radio');
    var comentario = $('comentario_id').value
    elements.each(function(item){      
      if(item.checked) radio_checked = true;
    });
    
    if($('decision_solicitud_id').value.length==0){
        $('error_decision_comite').show();
        $('error_solicitud').show();
        $('error_tipo_decision').hide();
        $('error_comentario').hide();
        //return false;
    }
    else if(comentario.length==0){
        $('error_decision_comite').show();
        $('error_comentario').show();
        $('error_solicitud').hide();
        $('error_tipo_decision').hide();
        //return false;
    }
    else if(!radio_checked) {
        $('error_decision_comite').show();
        $('error_tipo_decision').show();
        $('error_solicitud').hide();
        $('error_comentario').hide();
        //return false;
    }
    else if (confirm(mensaje)) {
        
        new Ajax.Request('/solicitudes/'+comite+'/decision_comite',
            {
                asynchronous:true,
                evalScripts:true,
                parameters:$('form_decision_comite').serialize(this),
                onLoaded:function(request){
                    image_unload();
                    new Ajax.Request('/solicitudes/'+comite+'/list', {asynchronous:false, evalScripts:true, onLoaded:function(request){Element.hide("loading")}, onLoading:function(request){Element.show("loading")}, parameters:$('form_'+comite+'_buscar').serialize(this)});
                    
                    $('decision_solicitud_id').value ="";
                    $('error_decision_comite').hide();
                    $('comentario_id').value="";
                    
                    $('tipo_decision_A').checked=false;
                    $('decision_aprobado').className="";
                    $('tipo_decision_R').checked=false;
                    $('decision_rechazado').className="";
                    $('tipo_decision_D').checked=false;
                    $('decision_diferido').className="";                    
                    $('message').innerHTML=mensaje2;
                    $('message').show();
                    
                    return false;
                    
                },
                onLoading:function(request){image_load();}
            }
        );
        
    }
    return false;
}
// Agrega un estilo al seleccionar un tipo de decision.
function addClassDecision(this_){
   $('decision_rechazado').removeClassName("decision_comite_rechazado");
   $('decision_diferido').removeClassName("decision_comite_diferido");
   $('decision_aprobado').removeClassName("decision_comite_aprobado");    
    switch (this_.value) {
        case 'A':
           $('decision_aprobado').addClassName("decision_comite_aprobado");
           break
        case 'R':
           $('decision_rechazado').addClassName("decision_comite_rechazado");
           break
        case 'D':
           $('decision_diferido').addClassName("decision_comite_diferido");
           break;
    }
}
// Limpia los campos que se encuentran en el formulario de decision del comite.
Event.observe(window, 'load', function() {
    $('decision_solicitud_id').value ="";
    var elements=$('form_decision_comite').getInputs('radio');
    elements.each(function(item){ item.checked=false; });
});