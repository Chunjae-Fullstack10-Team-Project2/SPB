package net.spb.spb.service;

import jakarta.servlet.ServletContext;
import net.spb.spb.dto.MemberDTO;
import net.spb.spb.util.HttpUtil;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;

@Service
public class NaverLoginService {

    @Autowired
    private ServletContext servletContext;
    String REDIRECT_URI = "http://localhost:8080/naver/callback";

    public String getAccessToken(String code, String state) throws Exception {
        String CLIENT_ID = servletContext.getInitParameter("naver.clientId");
        String CLIENT_SECRET = servletContext.getInitParameter("naver.clientSecret");
        String tokenUrl = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
                + "&client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&code=" + code
                + "&state=" + state;

        String response = HttpUtil.get(tokenUrl);
        JSONObject jsonResponse = new JSONObject(response);
        return jsonResponse.getString("access_token");
    }

    public MemberDTO getUserInfo(String accessToken) throws Exception {
        String profileUrl = "https://openapi.naver.com/v1/nid/me";
        String response = HttpUtil.get(profileUrl, accessToken);

        JSONObject jsonResponse = new JSONObject(response);
        JSONObject responseObj = jsonResponse.getJSONObject("response");

        String id = responseObj.getString("id");
        if (id.length() > 20) {
            id = id.substring(0, 20);
        }
        String email = "";
        if (!responseObj.getString("email").contains("@")) {
            email = responseObj.getString("email");
        } else {
            email = responseObj.getString("email").split("@")[0];
        }
        String name = responseObj.getString("name");
        String mobile = responseObj.getString("mobile").replace("-", "");
        String birthyear = responseObj.getString("birthyear");
        String birthday = responseObj.getString("birthday"); // MM-DD
        String birth = birthyear + birthday.replace("-", "");

        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setMemberEmail(email);
        memberDTO.setMemberName(name);
        memberDTO.setMemberId(id);
        memberDTO.setMemberPhone(mobile);
        memberDTO.setMemberBirth(birth);

        return memberDTO;
    }
}
