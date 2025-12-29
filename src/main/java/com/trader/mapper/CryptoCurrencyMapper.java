package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.CryptoCurrency;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CryptoCurrencyMapper extends BaseMapper<CryptoCurrency> {
}
