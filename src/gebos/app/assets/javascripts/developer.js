function ValidarNumero(nombre)
 {
  var campo =  $(nombre)
   if((isNaN(campo.value)) && (campo.value > "0")){
   alert('Los valores soportados son solo numéricos');
    campo.value = campo.value.replace(/[a-zA-Z]/,'');
   }
 }
 
 function recargar(){
    location.reload();
 }

function noEscribir(evt){
     
     var evt = evt || event; // DOM || IE;
     if(evt.keyCode == 46 || evt.keyCode == 116) // delete o f5;
     try{evt.preventDefault();}catch(error){evt.returnValue = false;}     
     //todos los demas teclas
     var charCode = (evt.which) ? evt.which : event.keyCode               
     if ((charCode < 65000 && charCode > 7))
        return false;
     return true;
}


function NumberKey(evt){
     var charCode = (evt.which) ? evt.which : event.keyCode
     if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
     return true;
}


function NumberDoubleKey(evt){
     var charCode = (evt.which) ? evt.which : event.keyCode
     if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 46)
        return false;
     return true;
}
 
 function mostrar_div(campo,nombre_div){
    //var plazo = $('condiciones_financiamiento_plazo').value;

    //alert(plazo);
    var nom_div = $(nombre_div);

    if (campo == 0)
       {
         $(nom_div).show();
       }
    else
      {
         $(nom_div).hide();
       }
  }

function GenericcheckAll(field, todos, div){
  var valor=""
  if ( field.value > 0 ){
    if (todos.checked == true) {
      field.checked = true;

      document.getElementById(div).value = ',' + field.value +',';

    } else {
      field.checked = false;
      alert(valor);
      document.getElementById(div).value = ',' + valor +',';
    }
  } else {
    for (i = 0; i < field.length; i++) {
      if (todos.checked == true) {
        field[i].checked = true;
        valor= valor + ',' + field[i].value;
      }
      else {
        field[i].checked = false;
        valor= valor;
      }
    }
                if (valor.charAt(0) == ','){
                    valor = valor.substring(1, valor.length)
                }
                if (valor.length > 0){
                    valor = valor + ','
                }
                document.getElementById(div).value = valor;
  }
}
function GenericcheckOne(field, todos, div){
  var valor = document.getElementById(div).value
  if (field.checked == false){
                valor = ',' + valor;
    valor= valor.replace(',' + field.value + ',' , ",");
    todos.checked=false;
  }
  else {
    valor = valor.replace(',' + field.value + ',' , ",")
    valor = valor + field.value + ',';
  }
        if (valor.charAt(0) == ','){
            valor = valor.substring(1, valor.length)
        }
  document.getElementById(div).value = valor;
}

function checkAll(field, todos){
  var valor=""
  var valor1=""
  if ( field.value > 0 ){
    if (todos.checked == true) {
      field.checked = true;
      document.getElementById("cuenta_id").value = ',' + field.value +',';
      document.getElementById("cuenta_id1").value = ',' + field.value +',';
    } else {
      field.checked = false
      document.getElementById("cuenta_id").value = ',' + valor +',';
      document.getElementById("cuenta_id1").value = ',' + valor +',';
    }
    valor = document.getElementById("cuenta_id").value
    valor1 = document.getElementById("cuenta_id1").value

    if (valor.charAt(0) == ','){
        valor = valor.substring(1, valor.length)
    }
    if (valor.length > 0){
        valor = valor + ','
    }
    document.getElementById("cuenta_id").value = valor
    if (valor1.charAt(0) == ','){
        valor1 = valor1.substring(1, valor1.length)
    }
    if (valor1.length > 0){
        valor1 = valor1 + ','
    }
    document.getElementById("cuenta_id1").value = valor1


  } else {
    for (i = 0; i < field.length; i++) {
      if (todos.checked == true) {
        field[i].checked = true;
        valor= valor + ',' + field[i].value;
      }
      else {
        field[i].checked = false;
        valor= valor;
      }
    }
                if (valor.charAt(0) == ','){
                    valor = valor.substring(1, valor.length)
                }
                if (valor.length > 0){
                    valor = valor + ','
                }
                document.getElementById("cuenta_id").value = valor
                document.getElementById("cuenta_id1").value = valor
  }
}
function checkOne(field, todos){
  var valor = document.getElementById("cuenta_id").value
  if (field.checked == false){
                valor = ',' + valor;
    valor= valor.replace(',' + field.value + ',' , ",");
    todos.checked=false;
  }
  else {
    valor = valor.replace(',' + field.value + ',' , ",")
    valor = valor + field.value + ',';
  }
        if (valor.charAt(0) == ','){
            valor = valor.substring(1, valor.length)
        }
  document.getElementById("cuenta_id").value = valor;
  document.getElementById("cuenta_id1").value = valor;
}


function checkUsoOtro(){
  var valor=""
  if (document.getElementById("empresa_uso_otro").checked == false)
  {
    document.getElementById("empresa_descripcion_otro").value = valor;
    document.getElementById("empresa_descripcion_otro").readOnly=true;
  }
  else
  {
    document.getElementById("empresa_descripcion_otro").readOnly=false;

  }
}

function checkUpsUsoOtro(){
  var valor=""
  if (document.getElementById("ups_uso_otro").checked == false)
  {
    document.getElementById("ups_descripcion_otro").value = valor;
    document.getElementById("ups_descripcion_otro").readOnly=true;
  }
  else
  {
    document.getElementById("ups_descripcion_otro").readOnly=false;

  }

}
function checktenencia(){

  if (document.getElementById("empresa_direccion_tenencia_a").checked == true)
  {
    document.getElementById("empresa_direccion_alquiler_mensual").readOnly=false;
  }
  else
  {
    document.getElementById("empresa_direccion_alquiler_mensual").value = "0"
    document.getElementById("empresa_direccion_alquiler_mensual").readOnly=true;

  }

}
function montosolicitud(){
  var monto = document.getElementById("solicitud_monto_cliente_f").value
  document.getElementById("solicitud_monto_solicitado_f").value = monto
}

function enviar_precomite(id){
  if (document.getElementById('solicitud_estatus_consejo_a').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_a').value;
  }
  else if (document.getElementById('solicitud_estatus_consejo_r').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_r').value;
  }
  else if (document.getElementById('solicitud_estatus_consejo_d').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_d').value;
  }

    var comentario_consejo = document.getElementById('solicitud_comentario_consejo').value;
  if (confirm('¿Está usted seguro que desea avanzar esta Solicitud?')) {
    new Ajax.Request('/solicitudes/solicitud_consejo/avanzar?id='+id+'&estatus_consejo='+estatus_consejo+'&comentario_consejo='+comentario_consejo, {asynchronous:true, evalScripts:true, onLoaded:function(request){image_unload()}, onLoading:function(request){image_load()}}); }; return false;

}
function changeButton(){
  if (document.getElementById('solicitud_estatus_consejo_a').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_a').value;
  }
  else if (document.getElementById('solicitud_estatus_consejo_r').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_r').value;
  }
  else if (document.getElementById('solicitud_estatus_consejo_d').checked == true)
  {
    var estatus_consejo = document.getElementById('solicitud_estatus_consejo_d').value;
  }
   new Ajax.Request('/solicitudes/solicitud_consejo/estatus_change?estatus_consejo='+estatus_consejo, {asynchronous:true, evalScripts:true, onLoaded:function(request){image_unload()}, onLoading:function(request){image_load()}});

}

function enviar_miembros(){
 var rol_comite_id     = "&rol_comite_id="+$("rol_comite_id").value;
 var miembro_comite_id = "&miembro_comite_id="+$('comite_miembro_miembro_comite_id').value;
 var comite_id         = "id="+ $("comite_id").value;
 var firma             = "&firma=false";
 $$('input[id="comite_miembro_firma"]').each(function(elem) {  firma="&firma="+elem.checked  });
 var params            = comite_id+rol_comite_id+miembro_comite_id+firma;

 if (confirm('¿Está usted seguro que desea Agregar este Miembro al Comité?')) {
    new Ajax.Request('/basico/instancia_comite_estadal/agregar_miembro?'+params,
        {
            asynchronous:true, evalScripts:true,
            onLoaded:function(request){image_unload()},
            onLoading:function(request){image_load()}
        }
    );
 };
 return false;
}

function enviar_miembros_edit(){
  var comite_numero = document.getElementById('comite_numero').value;
  var miembro_comite_id = document.getElementById('comite_miembro_miembro_comite_id').value;
  var comite_miembro_rol = document.getElementById('comite_miembro_rol').value;
  var comite_miembro_firma = document.getElementById('comite_miembro_firma').checked;

  if (confirm('¿Está usted seguro que desea Agregar este Miembro al Comité?')) {
    new Ajax.Request('/basico/apertura_comite/agregar_miembro_edit?comite_numero='+comite_numero+'&miembro_comite_id='+miembro_comite_id+'&comite_miembro_rol='+comite_miembro_rol+'&comite_miembro_firma='+comite_miembro_firma, {asynchronous:true, evalScripts:true, onLoaded:function(request){image_unload()}, onLoading:function(request){image_load()}}); }; return false;
}
function fecha_firma_contrato(){
  var fecha = document.getElementById("fecha_firma_f").value
  document.getElementById("fecha_firma_contrato_f").value = fecha
}
function actualizar_numero_comite()
{
   var instancia_tipo_id = document.getElementById('comite_instancia_tipo_id').value;
   new Ajax.Request('/basico/apertura_comite/actualizar_nro_instancia?nro_instancia='+instancia_tipo_id, {asynchronous:true, evalScripts:true, onLoaded:function(request){image_unload()}, onLoading:function(request){image_load()}});
   return false;
}

function GenericcheckMontoOne(field, todos, div){
  var valor = document.getElementById(div).value
  if (field.checked == false){
                valor = ',' + valor;
    valor= valor.replace(',' + field.value + ',' , ",");
    todos.checked=false;
    document.getElementById('monto_recomendado_'+field.value).value='0';
    document.getElementById('monto_recomendado_'+field.value).disabled=true;
  }
  else {
    valor = valor.replace(',' + field.value + ',' , ",")
    valor = valor + field.value + ',';
    document.getElementById('monto_recomendado_'+field.value).disabled=false;
  }
        if (valor.charAt(0) == ','){
            valor = valor.substring(1, valor.length)
        }
  document.getElementById(div).value = valor;
}

function GenericcheckMontoAll(field, todos, div){
  var valor=""
  if ( field.value > 0 ){
    if (todos.checked == true) {
      field.checked = true;

      document.getElementById(div).value = field.value +',';

    } else {
      field.checked = false;
      //alert(valor);
      document.getElementById(div).value = valor +',';
    }
  } else {
    for (i = 0; i < field.length; i++) {
      if (todos.checked == true) {
          if (field[i].disabled == false) {
            field[i].checked = true;
            valor= valor + ',' + field[i].value;
            document.getElementById('monto_recomendado_'+field[i].value).disabled=false;
        }

      }
      else {
        field[i].checked = false;
        valor= valor;
        document.getElementById('monto_recomendado_'+field[i].value).value='0';
        document.getElementById('monto_recomendado_'+field[i].value).disabled=true;

      }
    }
                if (valor.charAt(0) == ','){
                    valor = valor.substring(1, valor.length)
                }
                if (valor.length > 0){
                    valor = valor + ','
                }
                document.getElementById(div).value = valor;
  }
}

// mredkj.com
function NumberFormat(num, inputDecimal)
  {
      this.VERSION = 'Number Format v1.5.4';
      this.COMMA = ',';
      this.PERIOD = '.';
      this.DASH = '-'; 
      this.LEFT_PAREN = '('; 
      this.RIGHT_PAREN = ')'; 
      this.LEFT_OUTSIDE = 0; 
      this.LEFT_INSIDE = 1;  
      this.RIGHT_INSIDE = 2;  
      this.RIGHT_OUTSIDE = 3;  
      this.LEFT_DASH = 0; 
      this.RIGHT_DASH = 1; 
      this.PARENTHESIS = 2; 
      this.NO_ROUNDING = -1 
      this.num;
      this.numOriginal;
      this.hasSeparators = false;  
      this.separatorValue;  
      this.inputDecimalValue; 
      this.decimalValue;  
      this.negativeFormat; 
      this.negativeRed; 
      this.hasCurrency;  
      this.currencyPosition;  
      this.currencyValue;  
      this.places;
      this.roundToPlaces; 
      this.truncate; 
      this.setNumber = setNumberNF;
      this.toUnformatted = toUnformattedNF;
      this.setInputDecimal = setInputDecimalNF; 
      this.setSeparators = setSeparatorsNF; 
      this.setCommas = setCommasNF;
      this.setNegativeFormat = setNegativeFormatNF; 
      this.setNegativeRed = setNegativeRedNF; 
      this.setCurrency = setCurrencyNF;
      this.setCurrencyPrefix = setCurrencyPrefixNF;
      this.setCurrencyValue = setCurrencyValueNF; 
      this.setCurrencyPosition = setCurrencyPositionNF; 
      this.setPlaces = setPlacesNF;
      this.toFormatted = toFormattedNF;
      this.toPercentage = toPercentageNF;
      this.getOriginal = getOriginalNF;
      this.moveDecimalRight = moveDecimalRightNF;
      this.moveDecimalLeft = moveDecimalLeftNF;
      this.getRounded = getRoundedNF;
      this.preserveZeros = preserveZerosNF;
      this.justNumber = justNumberNF;
      this.expandExponential = expandExponentialNF;
      this.getZeros = getZerosNF;
      this.moveDecimalAsString = moveDecimalAsStringNF;
      this.moveDecimal = moveDecimalNF;
      this.addSeparators = addSeparatorsNF;
      
      if (inputDecimal == null) {
        this.setNumber(num, this.PERIOD);
      } else {
        this.setNumber(num, inputDecimal); 
      }
      
      this.setCommas(true);
      this.setNegativeFormat(this.LEFT_DASH); 
      this.setNegativeRed(false); 
      this.setCurrency(false); 
      this.setCurrencyPrefix('$');
      this.setPlaces(2);
      
  }
  
  function setInputDecimalNF(val)
  {
    this.inputDecimalValue = val;
  }
  
  function setNumberNF(num, inputDecimal)
  {
    if (inputDecimal != null) {
      this.setInputDecimal(inputDecimal); 
  }
  
  this.numOriginal = num;
  this.num = this.justNumber(num);
  
  }
  
  function toUnformattedNF()
  {
    return (this.num);
  }
  
  function getOriginalNF()
  {
    return (this.numOriginal);
  }
  
  function setNegativeFormatNF(format)
  {
    this.negativeFormat = format;
  }
  
  function setNegativeRedNF(isRed)
  {
    this.negativeRed = isRed;
  }
  
  function setSeparatorsNF(isC, separator, decimal)
  {
    this.hasSeparators = isC;
    if (separator == null) separator = this.COMMA;
    if (decimal == null) decimal = this.PERIOD;
    if (separator == decimal) {
      this.decimalValue = (decimal == this.PERIOD) ? this.COMMA : this.PERIOD;
    } 
      else {
          this.decimalValue = decimal;
           }
          this.separatorValue = separator;
    }
    
    function setCommasNF(isC)
    {
      this.setSeparators(isC, this.COMMA, this.PERIOD);
    }
    
    function setCurrencyNF(isC)
    {
      this.hasCurrency = isC;
    }
    
    function setCurrencyValueNF(val)
    {
      this.currencyValue = val;
    }
    
      function setCurrencyPrefixNF(cp)
    {
      this.setCurrencyValue(cp);
      this.setCurrencyPosition(this.LEFT_OUTSIDE);
    }
    
    function setCurrencyPositionNF(cp)
    {
      this.currencyPosition = cp
    }
    
    function setPlacesNF(p, tr)
    {
      this.roundToPlaces = !(p == this.NO_ROUNDING); 
      this.truncate = (tr != null && tr); 
      this.places = (p < 0) ? 0 : p; 
    }
    
    function addSeparatorsNF(nStr, inD, outD, sep)
    {
      nStr += '';
      var dpos = nStr.indexOf(inD);
      var nStrEnd = '';
      if (dpos != -1) {
        nStrEnd = outD + nStr.substring(dpos + 1, nStr.length);
        nStr = nStr.substring(0, dpos);
      }
      
      var rgx = /(\d+)(\d{3})/;
      while (rgx.test(nStr)) {
      nStr = nStr.replace(rgx, '$1' + sep + '$2');
      }
      return nStr + nStrEnd;
     }
     
    function toFormattedNF()
    {	
      var pos;
      var nNum = this.num; 
      var nStr;            
      var splitString = new Array(2);   
      if (this.roundToPlaces) {
        nNum = this.getRounded(nNum);
        nStr = this.preserveZeros(Math.abs(nNum)); 
      } else {
        nStr = this.expandExponential(Math.abs(nNum)); 
      }
      
      if (this.hasSeparators) {
        nStr = this.addSeparators(nStr, this.PERIOD, this.decimalValue, this.separatorValue);
      } else {
         nStr = nStr.replace(new RegExp('\\' + this.PERIOD), this.decimalValue); 
        }
        
          var c0 = '';
          var n0 = '';
          var c1 = '';
          var n1 = '';
          var n2 = '';
          var c2 = '';
          var n3 = '';
          var c3 = '';
          var negSignL = (this.negativeFormat == this.PARENTHESIS) ? this.LEFT_PAREN : this.DASH;
          var negSignR = (this.negativeFormat == this.PARENTHESIS) ? this.RIGHT_PAREN : this.DASH;
          
          if (this.currencyPosition == this.LEFT_OUTSIDE) {
            if (nNum < 0) {
              if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n1 = negSignL;
              if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n2 = negSignR;
              }
            if (this.hasCurrency) c0 = this.currencyValue;
              } else if (this.currencyPosition == this.LEFT_INSIDE) {
              if (nNum < 0) {
              if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n0 = negSignL;
              if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n3 = negSignR;
              }
              if (this.hasCurrency) c1 = this.currencyValue;
              }
              else if (this.currencyPosition == this.RIGHT_INSIDE) {
              if (nNum < 0) {
              if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n0 = negSignL;
              if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n3 = negSignR;
              }
              if (this.hasCurrency) c2 = this.currencyValue;
              }
              else if (this.currencyPosition == this.RIGHT_OUTSIDE) {
              if (nNum < 0) {
              if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n1 = negSignL;
              if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n2 = negSignR;
              }
              if (this.hasCurrency) c3 = this.currencyValue;
              }
              nStr = c0 + n0 + c1 + n1 + nStr + n2 + c2 + n3 + c3;
              if (this.negativeRed && nNum < 0) {
              nStr = '<font color="red">' + nStr + '</font>';
              }
          return (nStr);
  }
      
  function toPercentageNF()
  {
    nNum = this.num * 100;
    nNum = this.getRounded(nNum);
    return nNum + '%';
    }
    function getZerosNF(places)
    {
    var extraZ = '';
    var i;
    for (i=0; i<places; i++) {
    extraZ += '0';
    }
    return extraZ;
    }
    function expandExponentialNF(origVal)
    {
    if (isNaN(origVal)) return origVal;
    var newVal = parseFloat(origVal) + ''; 
    var eLoc = newVal.toLowerCase().indexOf('e');
    if (eLoc != -1) {
    var plusLoc = newVal.toLowerCase().indexOf('+');
    var negLoc = newVal.toLowerCase().indexOf('-', eLoc); 
    var justNumber = newVal.substring(0, eLoc);
    if (negLoc != -1) {
    var places = newVal.substring(negLoc + 1, newVal.length);
    justNumber = this.moveDecimalAsString(justNumber, true, parseInt(places));
    } else {
    if (plusLoc == -1) plusLoc = eLoc;
    var places = newVal.substring(plusLoc + 1, newVal.length);
    justNumber = this.moveDecimalAsString(justNumber, false, parseInt(places));
    }
    newVal = justNumber;
    }
    return newVal;
  } 
  
  function moveDecimalRightNF(val, places)
  {
    var newVal = '';
    if (places == null) {
      newVal = this.moveDecimal(val, false);
    } else {
      newVal = this.moveDecimal(val, false, places);
    }
    return newVal;
   }
    
  function moveDecimalLeftNF(val, places)
  {
  var newVal = '';
  if (places == null) {
    newVal = this.moveDecimal(val, true);
  } else {
    newVal = this.moveDecimal(val, true, places);
  }
  return newVal;
}

  function moveDecimalAsStringNF(val, left, places)
  {
    var spaces = (arguments.length < 3) ? this.places : places;
    if (spaces <= 0) return val; 
    var newVal = val + '';
    var extraZ = this.getZeros(spaces);
    var re1 = new RegExp('([0-9.]+)');
    if (left) {
      newVal = newVal.replace(re1, extraZ + '$1');
      var re2 = new RegExp('(-?)([0-9]*)([0-9]{' + spaces + '})(\\.?)');		
      newVal = newVal.replace(re2, '$1$2.$3');
    } else {
      var reArray = re1.exec(newVal); 
      if (reArray != null) {
        newVal = newVal.substring(0,reArray.index) + reArray[1] + extraZ + newVal.substring(reArray.index + reArray[0].length); 
      }
      var re2 = new RegExp('(-?)([0-9]*)(\\.?)([0-9]{' + spaces + '})');
      newVal = newVal.replace(re2, '$1$2$4.');
    }
      newVal = newVal.replace(/\.$/, ''); 
    return newVal;
  }
  
  function moveDecimalNF(val, left, places)
  {
    var newVal = '';
    if (places == null) {
    newVal = this.moveDecimalAsString(val, left);
    } else {
    newVal = this.moveDecimalAsString(val, left, places);
    }
    return parseFloat(newVal);
  }
  
  function getRoundedNF(val)
  {
    val = this.moveDecimalRight(val);
    if (this.truncate) {
    val = val >= 0 ? Math.floor(val) : Math.ceil(val); 
    } else {
    val = Math.round(val);
    }
    val = this.moveDecimalLeft(val);
    return val;
  }
  
  function preserveZerosNF(val)
  {
    var i;
    val = this.expandExponential(val);
    if (this.places <= 0) return val; 
    var decimalPos = val.indexOf('.');
    if (decimalPos == -1) {
    val += '.';
    for (i=0; i<this.places; i++) {
    val += '0';
    }
    } else {
    var actualDecimals = (val.length - 1) - decimalPos;
    var difference = this.places - actualDecimals;
    for (i=0; i<difference; i++) {
    val += '0';
    }
    }
    return val;
  }

  function justNumberNF(val)
  {
    newVal = val + '';
    var isPercentage = false;
    if (newVal.indexOf('%') != -1) {
      newVal = newVal.replace(/\%/g, '');
      isPercentage = true; 
      }
      var re = new RegExp('[^\\' + this.inputDecimalValue + '\\d\\-\\+\\(\\)eE]', 'g');	
      newVal = newVal.replace(re, '');
      var tempRe = new RegExp('[' + this.inputDecimalValue + ']', 'g');
      var treArray = tempRe.exec(newVal);
      
      if (treArray != null) {
      var tempRight = newVal.substring(treArray.index + treArray[0].length); 
      newVal = newVal.substring(0,treArray.index) + this.PERIOD + tempRight.replace(tempRe, ''); 
      }
      if (newVal.charAt(newVal.length - 1) == this.DASH ) {
      newVal = newVal.substring(0, newVal.length - 1);
      newVal = '-' + newVal;
      }
      else if (newVal.charAt(0) == this.LEFT_PAREN
      && newVal.charAt(newVal.length - 1) == this.RIGHT_PAREN) {
      newVal = newVal.substring(1, newVal.length - 1);
      newVal = '-' + newVal;
      }
      newVal = parseFloat(newVal);
      if (!isFinite(newVal)) {
      newVal = 0;
      }
      if (isPercentage) {
        newVal = this.moveDecimalLeft(newVal, 2);
      }
    return newVal;
  }
  
  function calculaEdad(campo, nombre)
  {
      var Fa = new Date();
      var DFn = [];
      var Fn = document.getElementById(campo).value;
      var edad, Fa_anio,Fa_m, Fa_d, Fn_d, Fn_m, Fn_anio = null;
      
      DFn = Fn.split('/');
      
      Fn_d = DFn[0];
      Fn_m = DFn[1];
      Fn_anio = DFn[2];
      
      Fa_anio = Fa.getYear();
      Fa_m = Fa.getMonth();
      Fa_d = Fa.getDate();

      edad = ((Fa_anio + 1900) - Fn_anio)-1;

    if ( (Fa_m+1) > Fn_m) 
    {
      edad +=1;
    }
    if ( (Fa_m+1) <= Fn_m) {
        if (Fn_m == (Fa_m + 1))
        {
            if (Fa_d >= Fn_d)
            {
                edad +=1;
            }
        }
  }
    if (edad > 1900)
    {
    edad -= 1900;
    }
    document.getElementById(nombre).value = "";
    document.getElementById(nombre).value = edad;
  }

  function mostrar_filtros(){
      var div = document.getElementById('filters');
      div.style.display = 'block';
  }

  function ocultar_filtros(){
      var div = document.getElementById('filters');
      div.style.display = 'none';
  }