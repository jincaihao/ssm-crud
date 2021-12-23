<%--
  Created by IntelliJ IDEA.
  User: 金蔡浩
  Date: 2021/12/15
  Time: 16:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%
    application.setAttribute("APP_PATH", request.getContextPath());
%>
<head>
    <title>首页</title>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.6.0.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <%--一访问首页就发送Ajax请求，控制器方法返回JSON数据，解析JSON数据通过jQuery渲染页面--%>
    <script type="text/javascript">
        //全局变量：总记录数
        var totalRecordCount;
        //全局变量：当前页码
        var currentPageNum;
        $(function () {
            toPageNumOf(1);
        });

        /**
         * 发送Ajax请求
         * @param pageNum
         */
        function toPageNumOf(pageNum) {
            $.ajax({
                    url: "${APP_PATH}/list",
                    data: "pageNum=" + pageNum,
                    type: "GET",
                    success: function (result) {
                        buildEmpsTable(result);
                        buildPageInfo(result);
                        buildPageNav(result);
                    },
                    dataType: "json"
                }
            );
        }

        //从JSON数据中解析员工信息，并追加到DIV(#empTable tbody)中
        function buildEmpsTable(result) {
            //由于每次点击页码会重新发送一次Ajax请求，内容也会追加上去，所以追加方法得先"清空"原有内容
            $("#empTable tbody").empty();
            var emps = result.extend.pageInfo.list;
            $.each(emps, function (index, item) {
                var checkTd = $("<td></td>").append($("<input type='checkbox' name='item' class='checkItem'></input>").addClass("checkbox"))
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender == "1" ? "男" : "女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.dept.deptName);
                var editBtn = $("<button></button>").attr("edit-id", item.empId).addClass("btn btn-primary btn-xs editBtn").append("<span></span>")
                    .addClass("glyphicon glyphicon-text-size").append("编辑");
                var deleteBtn = $("<button></button>").attr("delete-id", item.empId).addClass("btn btn-warning btn-xs deleteBtn").append("<span></span>")
                    .addClass("glyphicon glyphicon-remove").append("删除");
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);
                $("<tr></tr>").append(checkTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#empTable tbody");
            });
        }

        //解析分页信息
        function buildPageInfo(result) {
            /**
             *             当前第<span class="label label-primary">${pageInfo.pageNum}</span>页，
             *                共有<span class="label label-primary">${pageInfo.pages}</span>页，
             *                   总计<span class="label label-primary">${pageInfo.total}</span>条记录
             */
            //清空原分页信息
            $("#pageInfoArea").empty();
            var pageNum = $("<kbd></kbd>").append(result.extend.pageInfo.pageNum);
            var pages = $("<kbd></kbd>").append(result.extend.pageInfo.pages);
            var total = $("<kbd></kbd>").append(result.extend.pageInfo.total);
            totalRecordCount = result.extend.pageInfo.total;
            currentPageNum = result.extend.pageInfo.pageNum;
            $("#pageInfoArea").append("当前第").append(pageNum).append("页，")
                .append("共有").append(pages).append("页，")
                .append("总计").append(total).append("条记录");

        }

        //解析分页条信息
        function buildPageNav(result) {
            //清空原分页导航条
            $("#pageNavArea").empty();
            var firstPageLi = $("<li></li>").append($("<a></a>").attr("href", "#").append(("首页")));
            var lastPageLi = $("<li></li>").append($("<a></a>").attr("href", "#").append(("末页")));
            var prePageLi = $("<li></li>").append($("<a></a>").attr("href", "#").attr("aria-label", "Previous").append(("&laquo;")));
            var sufPageLi = $("<li></li>").append($("<a></a>").attr("href", "#").attr("aria-label", "Next").append(("&raquo;")));

            //如果是第一页，添加禁用样式，并且不发请求
            if (result.extend.pageInfo.isFirstPage == true) {
                firstPageLi.addClass("disabled");
                // firstPageLi.unbind("click");
                prePageLi.addClass("disabled");
                // prePageLi.unbind("click");
            } else {
                firstPageLi.click(function () {
                    toPageNumOf(1);
                });
                prePageLi.click(function () {
                    toPageNumOf(result.extend.pageInfo.pageNum - 1);
                });
            }
            if (result.extend.pageInfo.isLastPage == true) {
                sufPageLi.addClass("disabled");
                // sufPageLi.unbind("click");
                lastPageLi.addClass("disabled");
                // lastPageLi.unbind("click");
            } else {
                lastPageLi.click(function () {
                    toPageNumOf(result.extend.pageInfo.pages);
                });

                sufPageLi.click(function () {
                    toPageNumOf(result.extend.pageInfo.pageNum + 1);
                });
            }
            var ul = $("<ul></ul>").addClass("pagination").append(firstPageLi).append(prePageLi);
            $.each(result.extend.pageInfo.navigatepageNums, function (index, num) {
                //如果是当前页，添加活动样式。
                if (result.extend.pageInfo.pageNum == num) {
                    var navigatePageLi = $("<li></li>").addClass("active").append($("<span></span>").append(num).attr("href", "#"));
                    ul.append(navigatePageLi);
                } else {
                    var navigatePageLi = $("<li></li>").append($("<a></a>").append(num).attr("href", "#"));
                    ul.append(navigatePageLi);
                }
                navigatePageLi.click(function () {
                    toPageNumOf(num);
                });
            });
            ul.append(sufPageLi).append(lastPageLi);
            $("<nav></nav>").append(ul).attr("aria-label", "Page navigation").appendTo("#pageNavArea");
        }

        //***************************************************************新增员工*********************************************************
        $(function () {
            $("#addEmpBtn").click(function () {
                //关闭模态框后再次打开清除表单信息
                // （不清空的话，如果上一次是成功的，又没有重新发Ajax，这打开内容又是校验成功的依然可以保存，可能会跳过某些校验，如重名校验）
                $("#addEmpModal form")[0].reset();    //这里使用DOM对象，因为jQuery没有reset方法
                //也清空之前可能添加的检验状态
                $("#addEmpModal form #empNameInput").parent().removeClass("has-success has-error");
                $("#addEmpModal form #empNameInput").next().empty();
                $("#addEmpModal form #emailInput").parent().removeClass("has-success has-error");
                $("#addEmpModal form #emailInput").next().empty();

                //取得部门信息
                $.ajax({
                    url: "${APP_PATH}/depts",
                    type: "GET",
                    success: function (result) {
                        console.log(result);
                        buildDeptNameSelect(result);
                    },
                    dataType: "json"
                });
                //显示模态框
                $("#addEmpModal").modal({
                    backdrop: "static"
                });
            });


            //对所有表单元素进行校验
            function validateAddEmpForm() {
                //获取表单输入的内容
                var email = $("#addEmpModal form #emailInput").val();
                var empName = $("#addEmpModal form #empNameInput").val();

                //使用正则表达式
                var emailRegix = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                var nameRegix = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,8}$)/;// 匹配2-8位中文, 或3-16位字母下划线数字

                if (nameRegix.test(empName)) {//姓名格式正确
                    showValidateMsg("#addEmpModal form #empNameInput", "success", "");
                    //Ajax再校验姓名是否存在
                    $.ajax({
                        url: "${APP_PATH}/checkEmpName",
                        data: $("#addEmpModal form #empNameInput").serialize(),
                        type: "GET",
                        success: function (result) {
                            if (result.code === 100) {   //姓名已存在
                                showValidateMsg("#addEmpModal form #empNameInput", "error", "该员工姓名已存在");
                            } else if (result.code === 200) { //用户名可用
                                showValidateMsg("#addEmpModal form #empNameInput", "success", "");
                            }
                        },
                        dataType: "json"
                    });
                } else {
                    showValidateMsg("#addEmpModal form #empNameInput", "error", "用户名格式错误，用户名应为2-8中文，或3-16位字母下划线数字");
                    return false;
                }

                //检验邮箱
                if (emailRegix.test(email)) {//邮箱格式正确
                    showValidateMsg("#addEmpModal form #emailInput", "success", "");
                } else {
                    showValidateMsg("#addEmpModal form #emailInput", "error", "邮箱格式不正确");
                    return false;
                }

                return true;
            }

            //员工姓名及邮箱一改变就校验
            $("#addEmpModal form #empNameInput,#emailInput").change(function () {
                if (validateAddEmpForm()) {
                    $("#saveEmpBtn").prop("disabled", false);
                } else { //无效时禁用按钮
                    $("#saveEmpBtn").prop("disabled", true);
                }
            });

            //给表单控件添加"检验状态"以及显示错误信息
            function showValidateMsg(selector, status, msg) {
                //覆盖原检验状态及清空错误信息
                $(selector).parent().removeClass("has-success has-error");
                $(selector).next().empty();
                if ("success" === status) {
                    $(selector).parent().addClass("has-success");
                    $(selector).next().append(msg);
                } else if ("error" === status) {
                    $(selector).parent().addClass("has-error");
                    $(selector).next().append(msg);
                }
            }

            $("#saveEmpBtn").click(function () {
                //对表单进行前端校验
                if (!validateAddEmpForm()) {
                    return false;
                }

                //将经校验后表单的数据发送到服务器
                $.ajax({
                    url: "${APP_PATH}/saveEmp",
                    type: "POST",
                    data: $("#addEmpModal form").serialize(),  //表单序列化，表单数据格式name1=value1&name2=value2
                    //请求成功后回调函数:
                    success: function (result) {
                        //如果后端校验不过
                        if (result.code === 100) {
                            //显示失败信息
                            console.log(result)
                            //有哪个字段的错误信息就显示哪个字段的。
                            if (undefined != result.extend.errorFileds.email) {
                                //显示邮箱的错误信息
                                showValidateMsg("#addEmpModal form #emailInput", "error", result.extend.errorFileds.email);
                            }
                            if (undefined != result.extend.errorFileds.empName) {
                                showValidateMsg("#addEmpModal form #empNameInput", "error", result.extend.errorFileds.empName);
                            }

                        } else { //后端校验也通过
                            //1、模态框隐藏
                            $("#addEmpModal").modal('hide');
                            //2、显示添加的数据的那一页。
                            toPageNumOf(totalRecordCount);
                            //这里使用总记录数，这样即使添加了一条记录后会翻页，也会小于总记录数，然后因为分页合理化参数显示末页。
                        }
                    },
                    dataType: "json"
                });
            });

            function validateUpdateEmpEmail() {
                //验证邮箱
                var email = $("#updateEmpModal form #emailUpdateInput").val();
                var emailRegix = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if (emailRegix.test(email)) {//邮箱格式正确
                    showValidateMsg("#updateEmpModal form #emailUpdateInput", "success", "");
                    return true;
                } else {
                    showValidateMsg("#updateEmpModal form #emailUpdateInput", "error", "邮箱格式不正确");
                    return false;
                }
            }

            //邮箱一经改变
            $("#updateEmpModal form #emailUpdateInput").change(function () {
                //验证邮箱
                if (validateUpdateEmpEmail()) {//邮箱格式正确
                    $("#updateEmpBtn").prop("disabled", false);
                } else {
                    $("#updateEmpBtn").prop("disabled", true);
                }
            });

            //更新员工
            $("#updateEmpBtn").click(function () {
                if (!validateUpdateEmpEmail()) {
                    return false;
                }
                id = $(this).attr("edit-id");
                $.ajax({
                    url: "${APP_PATH}/emp/" + id,
                    type: "POST",
                    data: $("#updateEmpModal form").serialize() + "&_method=put",
                    // type:"PUT",
                    // data:$("#updateEmpModal form").serialize(),
                    success: function (result) {
                        //关闭更新用户模态框
                        $("#updateEmpModal").modal('hide');
                        //返回显示原来页面
                        toPageNumOf(currentPageNum);
                    },
                    dataType: "json"
                });
            });

            //全选 or 全不选
            $("#checkAll").click(function () {
                $(".checkItem").prop("checked", $(this).prop("checked"));
            });

            $(document).on("click", ".checkItem", function () {
                //如果复选框都选中，全选按钮也选中
                //判断当前选中的元素
                var flag = $(".checkItem:checked").length === $(".checkItem").length;
                $("#checkAll").prop("checked", flag);
            });


            $("#deleteListEmpsBtn").click(function () {
                //获取选中的记录的姓名和Id
                var empNames = "";
                var empIds = "";
                $.each($(".checkItem:checked"), function(){
                    empNames = empNames + $(this).parents("tr").find("td:eq(2)").text() + "，";
                    empIds = empIds + $(this).parents("tr").find("td:eq(1)").text() + "-";
                });
                empNames = empNames.substring(0, empNames.length-1);
                empIds = empIds.substring(0, empIds.length-1);
                if(confirm("你确定要删除【" + empNames + "】这些员工吗？")){//确定
                    $.ajax({
                        url:"${APP_PATH}/emp/" + empIds,
                        data:"_method=delete",
                        type:"POST",
                        success:function(){
                            //回到原页面
                            toPageNumOf(currentPageNum);
                        },
                        dataType:"json"
                    });
                }else{//取消
                }

            });

        });

        function buildDeptNameSelect(result) {
            $.each(result.extend.depts, function (index, dept) {
                var optionElement = $("<option></option>").append(dept.deptName).attr("value", dept.deptId);
                optionElement.appendTo($("#addEmpModal select"));
            });
        }

        //***************************************************************新增员工*********************************************************
        //***************************************************************更新员工*********************************************************

        $(document).on("click", ".editBtn", function () {
            //显示模态框
            $("#updateEmpModal").modal({
                backdrop: "static"
            });

            //部门名称
            $.ajax({
                url: "${APP_PATH}/depts",
                type: "GET",
                success: function (result) {
                    $("#updateEmpModal select").empty();
                    $.each(result.extend.depts, function (index, dept) {
                        var optionElement = $("<option></option>").append(dept.deptName).attr("value", dept.deptId);
                        optionElement.appendTo($("#updateEmpModal select"));
                    });
                },
                dataType: "json"
            });

            //员工信息
            //$(this).attr("edit-id") == 当前被点击的按钮
            getEmpBy($(this).attr("edit-id"));

            //点击编辑按钮时，传递员工id给更新按钮
            $("#updateEmpBtn").attr("edit-id", $(this).attr("edit-id"));

        });

        function getEmpBy(id) {
            $.ajax({
                url: "${APP_PATH}/emp/" + id,
                type: "GET",
                success: function (result) {
                    $("#empNameUpdateInput").empty();
                    //显示员工信息
                    console.log(result);
                    //姓名
                    $("#empNameUpdateInput").append(result.extend.emp.empName);
                    //邮箱
                    $("#emailUpdateInput").val(result.extend.emp.email);
                    //性别
                    $("#updateEmpModal input[name=gender]").val([result.extend.emp.gender]);
                    //所属部门
                    $("#updateEmpModal select").val([result.extend.emp.dId]);
                },
                dataType: "json"
            });
        }

        //***************************************************************更新员工*********************************************************
        //***************************************************************删除员工*********************************************************
        $(document).on("click", ".deleteBtn", function () {
            id = $(this).attr("delete-id");
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            if(!($(".checkItem:checked").length === 0)){
                if (confirm("确定要删除员工【" + empName + "】吗？")) {//点击确定
                    $.ajax({
                        url: "${APP_PATH}/emp/" + id,
                        type: "POST",
                        data: "_method=delete",
                        success: function () {//发送ajxa请求完成后
                            //回到原页面
                            toPageNumOf(currentPageNum);
                        },
                        dataType: "json"
                    });
                } else {//点击取消
                }
            }
        });
        //***************************************************************删除员工*********************************************************
    </script>
</head>
<body>
<!-- 添加员工Modal -->
<div class="modal fade" id="addEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empNameInput" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empNameInput" placeholder="如：张三">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="emailInput" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="emailInput"
                                   placeholder="如：email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input checked type="radio" name="gender" id="genderInput1" value="1"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="genderInput2" value="0"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所属部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEmpBtn">保存</button>
            </div>
        </div>
    </div>
</div>
<!-- 更新员工Modal -->
<div class="modal fade" id="updateEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">更新员工信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empNameUpdateInput" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empNameUpdateInput"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="emailUpdateInput" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="emailUpdateInput"
                                   placeholder="如：email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input checked type="radio" name="gender" id="genderUpdateInput1" value="1"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="genderUpdateInput2" value="0"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所属部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateEmpBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px">
        <div class="col-lg-4 col-lg-offset-8 text-center">
            <button type="button" class="btn btn-success" id="addEmpBtn">新增</button>
            <button type="button" class="btn btn-danger" id="deleteListEmpsBtn">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover" id="empTable">
                <%--表头--%>
                <thead>
                <tr>
                    <th><input type="checkbox" id="checkAll" style="height: 23px"></th>
                    <th>#</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Email</th>
                    <th>DeptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <%--填充数据--%>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <%--分页信息--%>
        <div class="col-lg-12 text-center" id="pageInfoArea">
        </div>
    </div>
    <div class="row">
        <%--分页导航条--%>
        <div class="col-lg-12 text-center" id="pageNavArea">
        </div>
    </div>
</div>
</body>
</html>
