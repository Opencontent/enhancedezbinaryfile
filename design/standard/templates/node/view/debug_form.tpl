{* Move this file to full and a non-overriden class will pick this up*}
<SCRIPT LANGUAGE="JavaScript" type="text/javascript">
<!--
{literal}
function checkAll()
{
{/literal}
    if ( document.fullview.selectall.value == "{'Select all'|i18n('design/standard/node/view')}" )
{literal}
    {
{/literal}
        document.fullview.selectall.value = "{'Deselect all'|i18n('design/standard/node/view')}";
{literal}
        with (document.fullview)
	{
            for (var i=0; i < elements.length; i++)
	    {
                if (elements[i].type == 'checkbox' && elements[i].name == 'DeleteIDArray[]')
                     elements[i].checked = true;
	    }
        }
     }
     else
     {
{/literal}
         document.fullview.selectall.value = "{'Select all'|i18n('design/standard/node/view')}";
{literal}
         with (document.fullview)
	 {
            for (var i=0; i < elements.length; i++)
	    {
                if (elements[i].type == 'checkbox' && elements[i].name == 'DeleteIDArray[]')
                     elements[i].checked = false;
	    }
         }
     }
}
{/literal}
//-->
</SCRIPT>

{* Default object admin view template *}
{default with_children=true()
         is_editable=true()
	 is_standalone=true()}
{let page_limit=15
     list_count=and($with_children,fetch('content','list_count',hash(parent_node_id,$node.node_id,depth_operator,eq)))}
{default content_object=$node.object
         content_version=$node.contentobject_version_object
         node_name=$node.name|wash}

{section show=$is_standalone}
<form enctype="multipart/form-data" name="fullview" method="post" action={"content/action"|ezurl}>
{/section}
<div class="object">
<h1>{$node_name}</h1>
<input type="hidden" name="TopLevelNode" value="{$content_object.main_node_id}" />

    {default validation=false()}
    {section show=$validation}
      {include name=Validation uri='design:content/collectedinfo_validation.tpl' validation=$validation collection_attributes=$collection_attributes}
    {/section}
    {/default}

    {section name=ContentObjectAttribute loop=$content_version.contentobject_attributes}
    <div class="block">
        <label>{$ContentObjectAttribute:item.contentclass_attribute.name|wash}</label>
    	<p class="box">{attribute_view_gui attribute=$ContentObjectAttribute:item}</p>
    </div>
    {/section}
</div>

    {let related_objects=$content_version.related_contentobject_array}

      {section name=ContentObject  loop=$related_objects show=$related_objects  sequence=array(bglight,bgdark)}
        <div class="block">
        {content_view_gui view=text_linked content_object=$Object:ContentObject:item}
        </div>
      {/section}
    {/let}

    {section show=$is_standalone}
    {let content_action_list=$content_object.content_action_list}
        {section name=ContentAction loop=$content_action_list show=$content_action_list}
            <div class="block">
                <input type="submit" name="{$ContentAction:item.action}" value="{$ContentAction:item.name|wash}" />
            </div>
        {/section}
    {/let}
    {/section}

<div class="buttonblock">
<input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
<input type="hidden" name="ContentObjectID" value="{$content_object.id}" />
<input type="hidden" name="ViewMode" value="full" />


{section show=$with_children}

{let name=Child
     children=fetch('content','list',hash(parent_node_id,$node.node_id,sort_by,$node.sort_array,limit,$page_limit,offset,$view_parameters.offset,depth_operator,eq))
     can_remove=false() can_edit=false() can_create=false() can_copy=false()}

{section show=$:children}

{section loop=$:children}
  {section show=$:item.object.can_remove}
    {set can_remove=true()}
  {/section}
  {section show=$:item.object.can_edit}
    {set can_edit=true()}
  {/section}
  {section show=$:item.object.can_create}
    {set can_create=true()}
  {/section}
{/section}

{set can_copy=$content_object.can_create}



<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    {section show=$:can_remove}
    <th width="1">
&nbsp;
    </th>
    {/section}
    <th>
      {"Name"|i18n("design/standard/node/view")}
    </th>
    <th>
      {"Class"|i18n("design/standard/node/view")}
    </th>
    <th>
      {"Section"|i18n("design/standard/node/view")}
    </th>
    {section show=eq($node.sort_array[0][0],'priority')}
    <th>
      {"Priority"|i18n("design/standard/node/view")}
    </th>
    {/section}
    {section show=$:can_edit}
    <th width="1">
      {"Edit"|i18n("design/standard/node/view")}
    </th>
    {/section}
    {section show=$:can_copy}
    <th width="1">
      {"Copy"|i18n("design/standard/node/view")}
    </th>
    {/section}
</tr>
{section loop=$:children sequence=array(bglight,bgdark)}
<tr class="{$Child:sequence}">
        {section show=$:can_remove}
	<td align="right" width="1">
	{section show=$:item.object.can_remove}
             <input type="checkbox" name="DeleteIDArray[]" value="{$Child:item.node_id}" />
        {/section}
	</td>
        {/section}
	<td>
        <a href={$:item.url_alias|ezurl}>{node_view_gui view=line content_node=$:item}</a>

{*        {node_view_gui view=line content_node=$:item} *}
	</td>
    <td>
        {$Child:item.object.class_name|wash}
	</td>
    <td>
        {$Child:item.object.section_id}
	</td>
	{section show=eq($node.sort_array[0][0],'priority')}
	<td width="40" align="left">
	    <input type="text" name="Priority[]" size="2" value="{$Child:item.priority}">
        <input type="hidden" name="PriorityID[]" value="{$Child:item.node_id}">
	</td>
	{/section}

        {section show=$:can_edit}
            <td width="1">
                {section show=$:item.object.can_edit}
                    <a href={concat("content/edit/",$Child:item.contentobject_id)|ezurl}><img src={"edit.gif"|ezimage} alt="Edit" /></a>
                {/section}
            </td>
        {/section}
        {section show=$:can_copy}
        <td>
          <a href={concat("content/copy/",$Child:item.contentobject_id)|ezurl}><img src={"copy.gif"|ezimage} alt="{'Copy'|i18n('design/standard/node/view')}" /></a>
        </td>
        {/section}

</tr>
{/section}
</table>

    {section show=eq($node.sort_array[0][0],'priority')}
      {section show=and($content_object.can_edit,eq($node.sort_array[0][0],'priority'))}
         <input class="button" type="submit"  name="UpdatePriorityButton" value="{'Update'|i18n('design/standard/node/view')}" />
      {/section}
    {/section}
    {section show=$:can_edit}
    {/section}
    {section show=$:can_copy}
    {/section}
    {section show=$:can_remove}
{*    {section show=fetch('content','list',hash(parent_node_id,$node.node_id,sort_by,$node.sort_array,limit,$page_limit,offset,$view_parameters.offset))}
    list_count*}
    {section show=$list_count}
            <input type="submit" name="RemoveButton" value="{'Remove'|i18n('design/standard/node/view')}" />
		<input name="selectall" onclick=checkAll() type="button" value="{'Select all'|i18n('design/standard/node/view')}">
    {/section}
    {/section}


{/section}
{/let}

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri=concat('/content/view','/full/',$node.node_id)
         item_count=$list_count
         view_parameters=$view_parameters
         item_limit=$page_limit}


{/section}


{section show=$is_standalone}
</form>
{/section}

{/default}
{/let}
{/default}

