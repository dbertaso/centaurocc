// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function ValidarNumero(str)
 {alert(isNaN(str));}

//-- Casa Proveedora
function NumberKey(evt){
     var charCode = (evt.which) ? evt.which : event.keyCode
     if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
     return true;
}

function AddSelectOption(selectObj, text, value, isSelected) {
    if (selectObj != null && selectObj.options != null) {
        selectObj.options[selectObj.options.length] =
            new Option(text, value, false, isSelected);
    }
}
function ShowHideElement(id,th){
  (th.value==1)? $(id).show(): $(id).hide();
  if(th.value==2){
    $$('input[id="casa_proveedora_tipo_cuenta_a"]').each(function(elem) {  elem.checked = false;  });
    $$('input[id="casa_proveedora_tipo_cuenta_c"]').each(function(elem) { elem.checked = false; }); 
    $('casa_proveedora_numero_cuenta').value = "" 
    var theSelectList = $('casa_proveedora_entidad_financiera_id');
    AddSelectOption(theSelectList, "Seleccione ...", "", true);
  }
 } 
//Event.observe(window, 'load', function() { if($("casa_proveedora_tipo_pago").value==2) $("forma_pago").hide()});
