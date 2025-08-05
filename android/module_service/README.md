###模块使用说明
*通过TheRouter依赖注入解耦,使用服务管理,暴露服务给其他模块*

1. 声明接口,其他组件通过接口来调用服务
```java
public interface HelloService extends IProvider {
    String sayHello(String name);
}
```
2. 在各自模块内实现接口
```java
@Route(path = "/yourservicegroupname/hello", name = "测试服务")
public class HelloServiceImpl implements HelloService {

    @Override
    public String sayHello(String name) {
    return "hello, " + name;
    }

    @Override
    public void init(Context context) {

    }
}
```
3. 通过依赖注入解耦:发现服务
```java
public class Test {
    @Autowired
    HelloService helloService;

    @Autowired(name = "/yourservicegroupname/hello")
    HelloService helloService2;

    HelloService helloService3;

    HelloService helloService4;

    public Test() {
    TheRouter.inject(this);
    }

    public void testService() {
    // 1. (推荐)使用依赖注入的方式发现服务,通过注解标注字段,即可使用，无需主动获取
    // Autowired注解中标注name之后，将会使用byName的方式注入对应的字段，不设置name属性，会默认使用byType的方式发现服务(当同一接口有多个实现的时候，必须使用byName的方式发现服务)
    helloService.sayHello("Vergil");
    helloService2.sayHello("Vergil");

    // 2. 使用依赖查找的方式发现服务，主动去发现服务并使用，下面两种方式分别是byName和byType
    helloService3 = TheRouter.navigation(HelloService.class);
    helloService4 = (HelloService) TheRouter.build("/yourservicegroupname/hello").navigation();
    helloService3.sayHello("Vergil");
    helloService4.sayHello("Vergil");
    }
}
```