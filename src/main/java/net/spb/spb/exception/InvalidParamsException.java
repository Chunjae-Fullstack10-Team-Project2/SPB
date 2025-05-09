package net.spb.spb.exception;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class InvalidParamsException extends RuntimeException {
    public InvalidParamsException(String message) {
        super(message);
        log.error("400 Bad Request: {}","Invalid parameters");
    }
}
