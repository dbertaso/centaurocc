/*
 * Generated by JasperReports - 4/10/07 5:48 PM
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
public class cuadro_resumen_de_financiamiento_1176241692215_751912 extends JREvaluator
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
    private JRFillParameter parameter_REPORT_VIRTUALIZER = null;
    private JRFillParameter parameter_REPORT_SCRIPTLET = null;
    private JRFillParameter parameter_REPORT_MAX_COUNT = null;
    private JRFillField field_monto = null;
    private JRFillField field_pago_cliente_id = null;
    private JRFillField field_prestamo_modificacion_id = null;
    private JRFillField field_fecha_contable = null;
    private JRFillField field_id = null;
    private JRFillField field_fecha_realizacion = null;
    private JRFillField field_tipo = null;
    private JRFillField field_fecha = null;
    private JRFillField field_proceso_nocturno = null;
    private JRFillField field_numero = null;
    private JRFillField field_prestamo_modifcacion_id = null;
    private JRFillField field_prestamo_id = null;
    private JRFillField field_desembolso_id = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;


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
        parameter_REPORT_VIRTUALIZER = (JRFillParameter)pm.get("REPORT_VIRTUALIZER");
        parameter_REPORT_SCRIPTLET = (JRFillParameter)pm.get("REPORT_SCRIPTLET");
        parameter_REPORT_MAX_COUNT = (JRFillParameter)pm.get("REPORT_MAX_COUNT");
    }


    /**
     *
     */
    private void initFields(Map fm)
    {
        field_monto = (JRFillField)fm.get("monto");
        field_pago_cliente_id = (JRFillField)fm.get("pago_cliente_id");
        field_prestamo_modificacion_id = (JRFillField)fm.get("prestamo_modificacion_id");
        field_fecha_contable = (JRFillField)fm.get("fecha_contable");
        field_id = (JRFillField)fm.get("id");
        field_fecha_realizacion = (JRFillField)fm.get("fecha_realizacion");
        field_tipo = (JRFillField)fm.get("tipo");
        field_fecha = (JRFillField)fm.get("fecha");
        field_proceso_nocturno = (JRFillField)fm.get("proceso_nocturno");
        field_numero = (JRFillField)fm.get("numero");
        field_prestamo_modifcacion_id = (JRFillField)fm.get("prestamo_modifcacion_id");
        field_prestamo_id = (JRFillField)fm.get("prestamo_id");
        field_desembolso_id = (JRFillField)fm.get("desembolso_id");
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
                value = (java.lang.Integer)(new Integer(1));
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
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 9 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 10 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 11 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
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
                value = (java.lang.Integer)(new Integer(1));
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
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 9 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 10 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 11 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
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
                value = (java.lang.Integer)(new Integer(1));
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
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 9 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 10 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 11 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(null);
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
