package com.kh.khsemiprj.exception;

import lombok.NoArgsConstructor;

@NoArgsConstructor
public class TargetNotFoundException extends RuntimeException{
	//public TargetNotfoundException() {}
	public TargetNotFoundException(String message) {
		super(message);
	}
}