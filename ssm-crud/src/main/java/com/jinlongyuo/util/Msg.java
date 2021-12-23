package com.jinlongyuo.util;

import java.util.HashMap;
import java.util.Map;

public class Msg {
    //状态码 200=成功 100=失败
    private Integer code;
    //提示信息
    private String msg;
    //存储用户数据的Map(用户要返回给浏览器的数据)
    private Map<String, Object> extend = new HashMap<>();

    public static Msg success(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMsg("处理成功");
        return msg;
    }

    public static Msg failed(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("处理失败");
        return msg;
    }

    //做一个链式调用结构
    public Msg add(String key, Object value){
        this.getExtend().put(key, value);
        return this;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
