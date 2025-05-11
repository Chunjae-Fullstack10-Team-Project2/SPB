package net.spb.spb.dto.pagingsearch;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;

@Getter
@Setter
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class PostPageDTO extends PageDTO {

    private String postCategory;

    @Builder.Default
    private String search_type="";

    private String search_date1;
    private String search_date2;

    public void normalizeSearchType() {
        if (this.search_type == null || this.search_type.isBlank()) {
            this.search_type = null;
            return;
        }

        switch (this.search_type) {
            case "title":
                this.search_type = "postTitle";
                break;
            case "content":
                this.search_type = "postContent";
                break;
            case "author":
                this.search_type = "postMemberId";
                break;
            default:
                this.search_type = null;
        }
    }

}
