package com.jinlongyuo.service;

import com.jinlongyuo.bean.Department;
import com.jinlongyuo.mapper.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {
    @Autowired
    DepartmentMapper departmentMapper;

    public List<Department> listDepts(){
        return departmentMapper.selectByExample(null);
    }
}
