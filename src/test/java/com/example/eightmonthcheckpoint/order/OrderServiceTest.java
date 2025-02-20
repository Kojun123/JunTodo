package com.example.eightmonthcheckpoint.order;

import com.example.eightmonthcheckpoint.member.Grade;
import com.example.eightmonthcheckpoint.member.Member;
import com.example.eightmonthcheckpoint.member.MemberService;
import com.example.eightmonthcheckpoint.member.MemberServiceImpl;
import org.junit.jupiter.api.Test;

public class OrderServiceTest {

    MemberService memberService = new MemberServiceImpl();
    OrderService orderService = new OrderServiceImpl();

    @Test
    void createOrder() {
        Long memberId = 1L;
        Member member = new Member(memberId, "memberA", Grade.VIP);
        memberService.join(member);

        Order order = orderService.createOrder(memberId, "item1", 1000);
    }
}
