/*
 * Generated by JasperReports - 4/13/07 1:37 AM
 */
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.fill.*;

import java.util.*;
import java.math.*;
import java.text.*;
import java.io.*;
import java.net.*;

import java.util.*;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.*;


/**
 *
 */
public class cuadro_resumen_de_financiamiento_1176442659949_283090 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_REPORT_DATE_FORMAT_FACTORY = null;
    private JRFillParameter parameter_REPORT_CLASS_LOADER = null;
    private JRFillParameter parameter_REPORT_TIME_ZONE = null;
    private JRFillParameter parameter_REPORT_DATA_SOURCE = null;
    private JRFillParameter parameter_REPORT_LOCALE = null;
    private JRFillParameter parameter_REPORT_URL_HANDLER_FACTORY = null;
    private JRFillParameter parameter_REPORT_PARAMETERS_MAP = null;
    private JRFillParameter parameter_REPORT_CONNECTION = null;
    private JRFillParameter parameter_IS_IGNORE_PAGINATION = null;
    private JRFillParameter parameter_SUBREPORT_DIR = null;
    private JRFillParameter parameter_REPORT_VIRTUALIZER = null;
    private JRFillParameter parameter_REPORT_SCRIPTLET = null;
    private JRFillParameter parameter_REPORT_MAX_COUNT = null;
    private JRFillField field_plazo_cuotas = null;
    private JRFillField field_id_solicitud = null;
    private JRFillField field_numero_de_resolucion_directorio = null;
    private JRFillField field_monto_aprobado_partida = null;
    private JRFillField field_partida_a_financiar = null;
    private JRFillField field_unidad_productiva = null;
    private JRFillField field_monto_aprobado = null;
    private JRFillField field_numero_de_resolucion_comite = null;
    private JRFillField field_desicion = null;
    private JRFillField field_tasa = null;
    private JRFillField field_indice_de_garantias = null;
    private JRFillField field_periodo_de_gracia = null;
    private JRFillField field_plazo_anos = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;
    private JRFillVariable variable_solicitud_COUNT = null;


    /**
     *
     */
    public void customizedInit(
        Map pm,
        Map fm,
        Map vm
        )
    {
        initParams(pm);
        initFields(fm);
        initVars(vm);
    }


    /**
     *
     */
    private void initParams(Map pm)
    {
        parameter_REPORT_RESOURCE_BUNDLE = (JRFillParameter)pm.get("REPORT_RESOURCE_BUNDLE");
        parameter_REPORT_DATE_FORMAT_FACTORY = (JRFillParameter)pm.get("REPORT_DATE_FORMAT_FACTORY");
        parameter_REPORT_CLASS_LOADER = (JRFillParameter)pm.get("REPORT_CLASS_LOADER");
        parameter_REPORT_TIME_ZONE = (JRFillParameter)pm.get("REPORT_TIME_ZONE");
        parameter_REPORT_DATA_SOURCE = (JRFillParameter)pm.get("REPORT_DATA_SOURCE");
        parameter_REPORT_LOCALE = (JRFillParameter)pm.get("REPORT_LOCALE");
        parameter_REPORT_URL_HANDLER_FACTORY = (JRFillParameter)pm.get("REPORT_URL_HANDLER_FACTORY");
        parameter_REPORT_PARAMETERS_MAP = (JRFillParameter)pm.get("REPORT_PARAMETERS_MAP");
        parameter_REPORT_CONNECTION = (JRFillParameter)pm.get("REPORT_CONNECTION");
        parameter_IS_IGNORE_PAGINATION = (JRFillParameter)pm.get("IS_IGNORE_PAGINATION");
        parameter_SUBREPORT_DIR = (JRFillParameter)pm.get("SUBREPORT_DIR");
        parameter_REPORT_VIRTUALIZER = (JRFillParameter)pm.get("REPORT_VIRTUALIZER");
        parameter_REPORT_SCRIPTLET = (JRFillParameter)pm.get("REPORT_SCRIPTLET");
        parameter_REPORT_MAX_COUNT = (JRFillParameter)pm.get("REPORT_MAX_COUNT");
    }


    /**
     *
     */
    private void initFields(Map fm)
    {
        field_plazo_cuotas = (JRFillField)fm.get("plazo_cuotas");
        field_id_solicitud = (JRFillField)fm.get("id_solicitud");
        field_numero_de_resolucion_directorio = (JRFillField)fm.get("numero_de_resolucion_directorio");
        field_monto_aprobado_partida = (JRFillField)fm.get("monto_aprobado_partida");
        field_partida_a_financiar = (JRFillField)fm.get("partida_a_financiar");
        field_unidad_productiva = (JRFillField)fm.get("unidad_productiva");
        field_monto_aprobado = (JRFillField)fm.get("monto_aprobado");
        field_numero_de_resolucion_comite = (JRFillField)fm.get("numero_de_resolucion_comite");
        field_desicion = (JRFillField)fm.get("desicion");
        field_tasa = (JRFillField)fm.get("tasa");
        field_indice_de_garantias = (JRFillField)fm.get("indice_de_garantias");
        field_periodo_de_gracia = (JRFillField)fm.get("periodo_de_gracia");
        field_plazo_anos = (JRFillField)fm.get("plazo_anos");
    }


    /**
     *
     */
    private void initVars(Map vm)
    {
        variable_PAGE_NUMBER = (JRFillVariable)vm.get("PAGE_NUMBER");
        variable_COLUMN_NUMBER = (JRFillVariable)vm.get("COLUMN_NUMBER");
        variable_REPORT_COUNT = (JRFillVariable)vm.get("REPORT_COUNT");
        variable_PAGE_COUNT = (JRFillVariable)vm.get("PAGE_COUNT");
        variable_COLUMN_COUNT = (JRFillVariable)vm.get("COLUMN_COUNT");
        variable_solicitud_COUNT = (JRFillVariable)vm.get("solicitud_COUNT");
    }


    /**
     *
     */
    public Object evaluate(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("/home/zforero/reportes_foncrei/financiamiento/");
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
                break;
            }
            case 13 : 
            {
                value = (java.lang.String)(((java.lang.String)field_unidad_productiva.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_comite.getValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_directorio.getValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(((java.lang.String)field_desicion.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 22 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_indice_de_garantias.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_partida_a_financiar.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado_partida.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_anos.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_cuotas.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_periodo_de_gracia.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()));
                break;
            }
            case 30 : 
            {
                value = (java.sql.Connection)(((java.sql.Connection)parameter_REPORT_CONNECTION.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(((java.lang.String)parameter_SUBREPORT_DIR.getValue()) + "garantias.jasper");
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateOld(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("/home/zforero/reportes_foncrei/financiamiento/");
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getOldValue()));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
                break;
            }
            case 13 : 
            {
                value = (java.lang.String)(((java.lang.String)field_unidad_productiva.getOldValue()));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado.getOldValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_comite.getOldValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_directorio.getOldValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(((java.lang.String)field_desicion.getOldValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 22 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa.getOldValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_indice_de_garantias.getOldValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_partida_a_financiar.getOldValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado_partida.getOldValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_anos.getOldValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_cuotas.getOldValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_periodo_de_gracia.getOldValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getOldValue()));
                break;
            }
            case 30 : 
            {
                value = (java.sql.Connection)(((java.sql.Connection)parameter_REPORT_CONNECTION.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(((java.lang.String)parameter_SUBREPORT_DIR.getValue()) + "garantias.jasper");
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateEstimated(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("/home/zforero/reportes_foncrei/financiamiento/");
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
                break;
            }
            case 13 : 
            {
                value = (java.lang.String)(((java.lang.String)field_unidad_productiva.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_comite.getValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_numero_de_resolucion_directorio.getValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(((java.lang.String)field_desicion.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 22 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_indice_de_garantias.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_partida_a_financiar.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_aprobado_partida.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_anos.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_cuotas.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_periodo_de_gracia.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()));
                break;
            }
            case 30 : 
            {
                value = (java.sql.Connection)(((java.sql.Connection)parameter_REPORT_CONNECTION.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(((java.lang.String)parameter_SUBREPORT_DIR.getValue()) + "garantias.jasper");
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
