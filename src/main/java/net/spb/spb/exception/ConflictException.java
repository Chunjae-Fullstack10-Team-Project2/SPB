package net.spb.spb.exception;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class ConflictException extends RuntimeException {
    public ConflictException(String message, String resource, int id) {
        super(message);
        log.error("409 Conflict: {} #{} conflict", resource, id);
    }
}
