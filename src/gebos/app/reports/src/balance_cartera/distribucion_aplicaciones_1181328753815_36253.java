/*
 * Generated by JasperReports - 6/8/07 2:52 PM
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
public class distribucion_aplicaciones_1181328753815_36253 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_REPORT_DATE_FORMAT_FACTORY = null;
    private JRFillParameter parameter_p_fecha = null;
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
    private JRFillField field_id_solicitud = null;
    private JRFillField field_numero_factura = null;
    private JRFillField field_intereses = null;
    private JRFillField field_id_factura = null;
    private JRFillField field_id_prestamo = null;
    private JRFillField field_id_pago_prestamo = null;
    private JRFillField field_id_pago_cliente = null;
    private JRFillField field_capital_cuota = null;
    private JRFillField field_intereses_mora = null;
    private JRFillField field_capital = null;
    private JRFillField field_numero_cuota = null;
    private JRFillField field_nombre_empresa = null;
    private JRFillField field_fecha_aplicacion = null;
    private JRFillField field_proceso = null;
    private JRFillField field_id_pago_cuota = null;
    private JRFillField field_numero_credito = null;
    private JRFillField field_modalidad = null;
    private JRFillField field_numero_prestamo = null;
    private JRFillField field_intereses_cuota = null;
    private JRFillField field_monto_pago = null;
    private JRFillField field_monto_cuota = null;
    private JRFillField field_id_empresa = null;
    private JRFillField field_intereses_mora_cuota = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;
    private JRFillVariable variable_factura_COUNT = null;
    private JRFillVariable variable_v_sum_capital_by_report = null;
    private JRFillVariable variable_v_sum_intereses_by_report = null;
    private JRFillVariable variable_v_sum_intereses_mora_by_report = null;
    private JRFillVariable variable_v_sum_monto_by_report = null;
    private JRFillVariable variable_v_proceso = null;
    private JRFillVariable variable_v_modalidad = null;


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
        parameter_p_fecha = (JRFillParameter)pm.get("p_fecha");
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
        field_id_solicitud = (JRFillField)fm.get("id_solicitud");
        field_numero_factura = (JRFillField)fm.get("numero_factura");
        field_intereses = (JRFillField)fm.get("intereses");
        field_id_factura = (JRFillField)fm.get("id_factura");
        field_id_prestamo = (JRFillField)fm.get("id_prestamo");
        field_id_pago_prestamo = (JRFillField)fm.get("id_pago_prestamo");
        field_id_pago_cliente = (JRFillField)fm.get("id_pago_cliente");
        field_capital_cuota = (JRFillField)fm.get("capital_cuota");
        field_intereses_mora = (JRFillField)fm.get("intereses_mora");
        field_capital = (JRFillField)fm.get("capital");
        field_numero_cuota = (JRFillField)fm.get("numero_cuota");
        field_nombre_empresa = (JRFillField)fm.get("nombre_empresa");
        field_fecha_aplicacion = (JRFillField)fm.get("fecha_aplicacion");
        field_proceso = (JRFillField)fm.get("proceso");
        field_id_pago_cuota = (JRFillField)fm.get("id_pago_cuota");
        field_numero_credito = (JRFillField)fm.get("numero_credito");
        field_modalidad = (JRFillField)fm.get("modalidad");
        field_numero_prestamo = (JRFillField)fm.get("numero_prestamo");
        field_intereses_cuota = (JRFillField)fm.get("intereses_cuota");
        field_monto_pago = (JRFillField)fm.get("monto_pago");
        field_monto_cuota = (JRFillField)fm.get("monto_cuota");
        field_id_empresa = (JRFillField)fm.get("id_empresa");
        field_intereses_mora_cuota = (JRFillField)fm.get("intereses_mora_cuota");
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
        variable_factura_COUNT = (JRFillVariable)vm.get("factura_COUNT");
        variable_v_sum_capital_by_report = (JRFillVariable)vm.get("v_sum_capital_by_report");
        variable_v_sum_intereses_by_report = (JRFillVariable)vm.get("v_sum_intereses_by_report");
        variable_v_sum_intereses_mora_by_report = (JRFillVariable)vm.get("v_sum_intereses_mora_by_report");
        variable_v_sum_monto_by_report = (JRFillVariable)vm.get("v_sum_monto_by_report");
        variable_v_proceso = (JRFillVariable)vm.get("v_proceso");
        variable_v_modalidad = (JRFillVariable)vm.get("v_modalidad");
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getValue()).booleanValue()== true?"Nocturno":"Diurno");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getValue())=="B"?"Banco Intermediado":"no aplica");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 32 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 33 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 34 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getValue()));
                break;
            }
            case 36 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getValue()));
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getValue()));
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getValue()));
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getValue()));
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getValue()));
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getValue()));
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getOldValue()));
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getOldValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getOldValue()));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getOldValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getOldValue()).booleanValue()== true?"Nocturno":"Diurno");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getOldValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getOldValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getOldValue())=="B"?"Banco Intermediado":"no aplica");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getOldValue()));
                break;
            }
            case 18 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getOldValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getOldValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getOldValue()));
                break;
            }
            case 21 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getOldValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getOldValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getOldValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getOldValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getOldValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getOldValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getOldValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getOldValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 32 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 33 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 34 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getOldValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getOldValue()));
                break;
            }
            case 36 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getOldValue()));
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getOldValue()));
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getOldValue()));
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getOldValue()));
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getOldValue()));
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getOldValue()));
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getOldValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getValue()).booleanValue()== true?"Nocturno":"Diurno");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getValue())=="B"?"Banco Intermediado":"no aplica");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getEstimatedValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getEstimatedValue()));
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 32 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 33 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 34 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getValue()));
                break;
            }
            case 36 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getValue()));
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getValue()));
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getValue()));
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getEstimatedValue()));
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getEstimatedValue()));
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getEstimatedValue()));
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getEstimatedValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
