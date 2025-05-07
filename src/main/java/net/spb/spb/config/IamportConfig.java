package net.spb.spb.config;

import com.siot.IamportRestClient.IamportClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class IamportConfig {

    @Bean
    public IamportClient iamportClient() {
        // 아임포트 REST API Key와 Secret
        return new IamportClient("5308452081165714", "k9aHUjxe7p8EHezB3AqXUCJ50XHQ9BydDigbryzrMxeXWvDfseFzy1HQ8bjXGqAuBSoWSJYytsnApRL1");
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}