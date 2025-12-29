package com.trader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.trader.entity.GlossaryTerm;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface GlossaryTermMapper extends BaseMapper<GlossaryTerm> {
    
    @Select("SELECT category_id, COUNT(*) as count FROM glossary_term WHERE status = 1 GROUP BY category_id")
    List<Map<String, Object>> countByCategory();
    
    @Select("SELECT t.*, c.name as category_name FROM glossary_term t " +
            "LEFT JOIN glossary_category c ON t.category_id = c.id " +
            "WHERE t.status = 1 ORDER BY t.view_count DESC LIMIT #{limit}")
    List<GlossaryTerm> getHotTerms(@Param("limit") int limit);
}
