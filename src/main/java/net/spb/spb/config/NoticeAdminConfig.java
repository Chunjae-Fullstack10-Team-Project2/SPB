package net.spb.spb.config;

import net.spb.spb.interceptor.NoticeAdminInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class NoticeAdminConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new NoticeAdminInterceptor())
                .addPathPatterns("/notice/regist", "/notice/modify", "/notice/delete",
                        "/notice/fix", "/notice/unfix");
    }
}