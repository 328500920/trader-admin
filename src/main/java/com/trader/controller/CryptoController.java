package com.trader.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.trader.common.Result;
import com.trader.entity.CryptoCurrency;
import com.trader.mapper.CryptoCurrencyMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/crypto")
@RequiredArgsConstructor
public class CryptoController {
    
    private final CryptoCurrencyMapper cryptoCurrencyMapper;
    
    /**
     * 获取所有启用的币种列表
     */
    @GetMapping("/list")
    public Result<List<CryptoCurrency>> list() {
        List<CryptoCurrency> list = cryptoCurrencyMapper.selectList(
            new LambdaQueryWrapper<CryptoCurrency>()
                .eq(CryptoCurrency::getStatus, 1)
                .orderByAsc(CryptoCurrency::getSortOrder)
        );
        return Result.success(list);
    }
}
