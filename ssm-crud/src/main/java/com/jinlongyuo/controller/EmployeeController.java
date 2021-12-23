package com.jinlongyuo.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jinlongyuo.bean.Employee;
import com.jinlongyuo.service.EmployeeService;
import com.jinlongyuo.util.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    //改为Ajax的查询
    /**
     *  使用@ResponseBody，需要导入jackson包（将对象转换为字符串）
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("/list")
    @ResponseBody
    public Msg list(@RequestParam(name = "pageNum", defaultValue = "1") Integer pageNum, Model model){
        PageHelper.startPage(pageNum, 6);
        List<Employee> employees = employeeService.getAll();
        PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }

    //普通的查询
    // @RequestMapping("/list")
    public String oldList(@RequestParam(name = "pageNum", defaultValue = "1") Integer pageNum, Model model){
        //引入分页插件并配置后，在查询之前只需调用该方法，即是分页查询
        PageHelper.startPage(pageNum, 6);
        List<Employee> employees = employeeService.getAll();
        //使用PageInfo来包装查询后的结果，只需要将pageInfo交给页面就好了
        //其中封装了详细的分页信息，包括我们的查询结果
        PageInfo<Employee> pageInfo = new PageInfo<>(employees, 5);
        //navigatePages参数代表连续显示的页数，可使用pageInfo.getNavigatepageNums()获取
        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }


    @RequestMapping(value = "/saveEmp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee,BindingResult result){
        if(result.hasErrors()){
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                //错误的字段名 及 错误的信息
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.failed().add("errorFileds", map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }


    @RequestMapping(value = "/checkEmpName", method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName")String empName){
        boolean isExist = employeeService.checkEmpName(empName);
        if(isExist){
            return Msg.failed();
        }else{
            return Msg.success();
        }
    }

    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmpById(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmpById(id);
        return Msg.success().add("emp", employee);
    }

    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("ids") String ids){
        if(ids.contains("-")){//如果是批量操作
            String[] list = ids.split("-");
            List<Integer> idList = new ArrayList<>();
            for (String s : list) {
                int i = Integer.parseInt(s);
                idList.add(i);
            }
            employeeService.deleteEmps(idList);
            return Msg.success();
        }else{//不是批量操作
            int id = Integer.parseInt(ids);
            employeeService.deleteEmpById(id);
            return Msg.success();
        }
    }
}
