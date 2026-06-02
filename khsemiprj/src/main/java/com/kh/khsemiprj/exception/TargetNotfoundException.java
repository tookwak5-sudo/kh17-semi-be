package com.kh.khsemiprj.exception;

import lombok.NoArgsConstructor;

@NoArgsConstructor
public class TargetNotfoundException extends RuntimeException {
	public TargetNotfoundException(String message) {
		super(message);
	}
}
