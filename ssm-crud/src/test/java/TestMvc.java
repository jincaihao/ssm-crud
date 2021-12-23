import com.github.pagehelper.PageInfo;
import com.jinlongyuo.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

//1、整合的测试框架版本
@RunWith(SpringJUnit4ClassRunner.class)
//2、使用的配置文件
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:springMVC.xml"})
@WebAppConfiguration //有了这个才可以注入Web的IOC
public class TestMvc {
    //传入SpringMVC的IOC（容器本身）
    @Autowired
    WebApplicationContext context;
    //虚拟mvc请求，获取到处理结果
    MockMvc mockMvc;

    //首先初始化，每次使用都得初始化
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        //请求
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/").param("pageNum", "5")).andReturn();

        //请求成功后：
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码：" + pageInfo.getPageNum());
        System.out.println("总页码：" + pageInfo.getPages());
        System.out.println("总记录数:" + pageInfo.getTotal());
        System.out.println("在页面需要连续显示的页码");
        int[] nums = pageInfo.getNavigatepageNums();
        for(int i : nums){
            System.out.print(i + " ");
        }
        System.out.println();

        //获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println(employee.getdId());
        }

    }

}
