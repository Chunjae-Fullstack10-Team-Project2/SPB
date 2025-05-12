package net.spb.spb.config;

import net.spb.spb.interceptor.LectureAccessInterceptor;
import net.spb.spb.service.lecture.LectureServiceIf;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@EnableWebMvc
@Configuration
@ComponentScan(basePackages = "net.spb.spb")
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LectureServiceIf lectureService;

    @Autowired
    private LectureAccessInterceptor lectureAccessInterceptor; // ✅ 자동 주입

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(lectureAccessInterceptor)
                .addPathPatterns("/lecture/chapter/play"); // ✅ 등록 경로도 문제 없음
    }
}
