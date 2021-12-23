package com.jinlongyuo.controller;

import com.jinlongyuo.bean.Department;
import com.jinlongyuo.service.DepartmentService;
import com.jinlongyuo.util.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    @RequestMapping(value = "/depts", method = RequestMethod.GET)
    @ResponseBody
    public Msg listDepts(){
        List<Department> depts = departmentService.listDepts();
        return Msg.success().add("depts", depts);
    }


}
