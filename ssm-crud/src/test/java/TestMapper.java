import com.jinlongyuo.bean.Employee;
import com.jinlongyuo.mapper.DepartmentMapper;
import com.jinlongyuo.mapper.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

//整合JUnit4后
//1、整合的测试框架版本
@RunWith(SpringJUnit4ClassRunner.class)
//2、使用的配置文件
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class TestMapper {
    //未整合JUnit的方式：
    // private ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
    // private EmployeeMapper mapper = ioc.getBean("EmployeeMapper", EmployeeMapper.class);

    @Autowired
    EmployeeMapper mapper;

    @Autowired
    DepartmentMapper dmapper;

    @Autowired
    SqlSession sqlSession;



    /**
     * 测试mapper注入是否成功，以及测试批量操作的SqlSession
     */
    @Test
    public void testCRUD(){
        System.out.println("============" + mapper);
        System.out.println("============" + dmapper);
        // mapper.insertSelective(new Employee(null, "我", "1", "@qq", 1));
        EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 100; i++) {
            String uuidName = UUID.randomUUID().toString().substring(0, 5) + i;
            employeeMapper.insertSelective(new Employee(null, uuidName, "1", "1214@qq.com", 1));
        }
    }

}
