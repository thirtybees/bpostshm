{*
* 2014 Stigmi
*
* @author Stigmi.eu <www.stigmi.eu>
* @author thirty bees <contact@thirtybees.com>
* @copyright 2014 Stigmi
* @copyright 2017 Thirty Development, LLC
* @license http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*}


{capture name='tr_count'}{counter name='tr_count'}{/capture}
<tbody>
{if count($list)}
  {foreach $list AS $index => $tr}
    <tr{if $position_identifier} id="tr_{$position_group_identifier|escape:'htmlall':'UTF-8'}_{$tr.$identifier|escape:'htmlall':'UTF-8'}_{if isset($tr.position['position'])}{$tr.position['position']|escape:'htmlall':'UTF-8'}{else}0{/if}"{/if} class="{if isset($tr.class)}{$tr.class|escape:'htmlall':'UTF-8'}{/if} {if $tr@iteration is odd by 1}odd{/if}"{if isset($tr.color) && $color_on_bg} style="background-color: {$tr.color|escape:'htmlall':'UTF-8'}"{/if} >
      {if $bulk_actions && $has_bulk_actions}
        <td class="text-center">
          {if isset($list_skip_actions.delete)}
            {if !in_array($tr.$identifier, $list_skip_actions.delete)}
              <input type="checkbox" name="{$list_id|escape:'htmlall':'UTF-8'}Box[]" value="{$tr.$identifier|escape:'htmlall':'UTF-8'}"{if isset($checked_boxes) && is_array($checked_boxes) && in_array({$tr.$identifier}, $checked_boxes)} checked="checked"{/if} class="noborder"/>
            {/if}
          {else}
            <input type="checkbox" name="{$list_id|escape:'htmlall':'UTF-8'}Box[]" value="{$tr.$identifier|escape:'htmlall':'UTF-8'}"{if isset($checked_boxes) && is_array($checked_boxes) && in_array({$tr.$identifier}, $checked_boxes)} checked="checked"{/if} class="noborder"/>
          {/if}
        </td>
      {/if}
      {foreach $fields_display AS $key => $params}
        {block name="open_td"}
          <td
          {if isset($params.position)}
            id="td_{if !empty($position_group_identifier)}{$position_group_identifier|escape:'htmlall':'UTF-8'}{else}0{/if}_{$tr.$identifier|escape:'htmlall':'UTF-8'}{if $smarty.capture.tr_count > 1}_{($smarty.capture.tr_count - 1)|intval}{/if}"
          {/if}
          class="{if !$no_link}pointer{/if}
						{if isset($params.position) && $order_by == 'position'  && $order_way != 'DESC'} dragHandle{/if}
						{if isset($params.class)} {$params.class|escape:'htmlall':'UTF-8'}{/if}
						{if isset($params.align)} {$params.align|escape:'htmlall':'UTF-8'}{/if}"
          {if (!isset($params.position) && !$no_link && !isset($params.remove_onclick))}
            onclick="document.location = '{$current_index|escape:'html':'UTF-8'}&amp;{$identifier|escape:'html':'UTF-8'}={$tr.$identifier|escape:'html':'UTF-8'}{if $view}&amp;view{else}&amp;update{/if}{$table|escape:'html':'UTF-8'}&amp;token={$token|escape:'html':'UTF-8'}'">
          {else}
            >
          {/if}
        {/block}
        {block name="td_content"}
          {if isset($params.prefix)}{$params.prefix}{/if}
          {if isset($params.badge_success) && $params.badge_success && isset($tr.badge_success) && $tr.badge_success == $params.badge_success}<span class="badge badge-success">{/if}
        {if isset($params.badge_warning) && $params.badge_warning && isset($tr.badge_warning) && $tr.badge_warning == $params.badge_warning}<span class="badge badge-warning">{/if}
        {if isset($params.badge_danger) && $params.badge_danger && isset($tr.badge_danger) && $tr.badge_danger == $params.badge_danger}<span class="badge badge-danger">{/if}
        {if isset($params.color) && isset($tr[$params.color])}
          <span class="label color_field" style="background-color:{$tr[$params.color]|escape:'htmlall':'UTF-8'};color:{if Tools::getBrightness($tr[$params.color]|escape) < 128}white{else}#383838{/if}">
        {/if}
          {if isset($tr.$key)}
            {if isset($params.active)}
              {$tr.$key|strval}
            {elseif isset($params.activeVisu)}
              {if $tr.$key}
                <i class="icon-check-ok"></i>
                       {l s='Enabled' mod='bpostshm'}
							{else}

                <i class="icon-remove"></i>
                {l s='Disabled' mod='bpostshm'}
              {/if}

						{elseif isset($params.position)}
							{if $order_by == 'position' && $order_way != 'DESC'}
              <div class="dragGroup">
									<div class="positions">
										{$tr.$key.position|intval}
									</div>
								</div>
            {else}
              {$tr.$key.position|intval + 1}
            {/if}
						{elseif isset($params.image)}
							{$tr.$key|strval}
						{elseif isset($params.icon)}
							{if is_array($tr[$key])}
              {if isset($tr[$key]['class'])}
                <i class="{$tr[$key]['class']|strval}"></i>

{else}

                <img src="../img/admin/{$tr[$key]['src']|strval}" alt="{$tr[$key]['alt']|strval}" title="{$tr[$key]['alt']|strval}"/>
              {/if}
							{else}

              <i class="{$tr[$key]|strval}"></i>
            {/if}
						{elseif isset($params.type) && $params.type == 'price'}
							{displayPrice price=$tr.$key}
						{elseif isset($params.float)}
							{$tr.$key|strval}
						{elseif isset($params.type) && $params.type == 'date'}
							{dateFormat date=$tr.$key full=0}
						{elseif isset($params.type) && $params.type == 'datetime'}
							{dateFormat date=$tr.$key full=1}
						{elseif isset($params.type) && $params.type == 'decimal'}
							{$tr.$key|string_format:"%.2f"}
						{elseif isset($params.type) && $params.type == 'percent'}
							{$tr.$key|strval} {l s='%' mod='bpostshm'}
						{* If type is 'editable', an input is created *}
						{elseif isset($params.type) && $params.type == 'editable' && isset($tr.id)}

              <input type="text" name="{$key|escape:'htmlall':'UTF-8'}_{$tr.id|escape:'htmlall':'UTF-8'}" value="{$tr.$key|escape:'html':'UTF-8'}" class="{$key|escape:'htmlall':'UTF-8'}"/>

{elseif isset($params.callback)}
							{if isset($params.maxlength) && Tools::strlen($tr.$key) > $params.maxlength}
              <span title="{$tr.$key|escape:'htmlall':'UTF-8'}">{$tr.$key|truncate:$params.maxlength:'...'}</span>
            {else}
              {$tr.$key|strval}
            {/if}
						{elseif $key == 'color'}
							{if !is_array($tr.$key)}
              <div style="background-color: {$tr.$key|strval};" class="attributes-color-container"></div>

{else} {*TEXTURE*}

              <img src="{$tr.$key.texture|strval}" alt="{$tr.name|strval}" class="attributes-color-container"/>
            {/if}
						{elseif isset($params.maxlength) && Tools::strlen($tr.$key) > $params.maxlength}

              <span title="{$tr.$key|escape:'html':'UTF-8'}">{$tr.$key|truncate:$params.maxlength:'...'|escape:'html':'UTF-8'}</span>
            {else}
              {$tr.$key|escape:'html':'UTF-8'}
            {/if}
          {else}
            {block name="default_field"}--{/block}
          {/if}
          {if isset($params.suffix)}{$params.suffix|escape:'htmlall':'UTF-8'}{/if}
        {if isset($params.color) && isset($tr.color)}
          </span>
        {/if}
        {if isset($params.badge_danger) && $params.badge_danger && isset($tr.badge_danger) && $tr.badge_danger == $params.badge_danger}</span>{/if}
        {if isset($params.badge_warning) && $params.badge_warning && isset($tr.badge_warning) && $tr.badge_warning == $params.badge_warning}</span>{/if}
          {if isset($params.badge_success) && $params.badge_success && isset($tr.badge_success) && $tr.badge_success == $params.badge_success}</span>{/if}
        {/block}
        {block name="close_td"}
          </td>
        {/block}
      {/foreach}

      {if $shop_link_type}
        <td title="{$tr.shop_name|escape:'htmlall':'UTF-8'}">
          {if isset($tr.shop_short_name)}
            {$tr.shop_short_name|escape:'htmlall':'UTF-8'}
          {else}
            {$tr.shop_name|escape:'htmlall':'UTF-8'}
          {/if}
        </td>
      {/if}
      {if $has_actions}
        <td class="txt-right" style="white-space: nowrap;">
          <select class="actions">
            <option value="">-</option>
            {foreach $actions AS $action}
              {if isset($tr.$action)}
                {$tr.$action|strval}
              {/if}
            {/foreach}
          </select>
        </td>
      {/if}
    </tr>
  {/foreach}
{else}
  <tr>
    <td class="list-empty" colspan="{$fields_display|count}">
      <div class="list-empty-msg">
        <i class="icon-warning-sign list-empty-icon"></i>
        {l s='No records found' mod='bpostshm'}
      </div>
    </td>
  </tr>
{/if}
</tbody>
