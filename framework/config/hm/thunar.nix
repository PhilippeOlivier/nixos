{
  home = {
    # file.".config/gtk-3.0/bookmarks".text = ''
    #   file:///home/pholi/some-directory
    # '';

    file.".config/xfce4/help.rc".text = ''
      auto-online=false
    '';

    file.".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="thunar" version="1.0">
        <property name="last-view" type="string" value="ThunarDetailsView"/>
        <property name="last-location-bar" type="string" value="ThunarLocationEntry"/>
        <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
        <property name="last-window-width" type="int" value="956"/>
        <property name="last-window-height" type="int" value="1036"/>
        <property name="last-window-maximized" type="bool" value="true"/>
        <property name="hidden-bookmarks" type="array">
          <value type="string" value="computer:///"/>
          <value type="string" value="network:///"/>
          <value type="string" value="file:///home/pholi/Desktop"/>
        </property>
        <property name="last-separator-position" type="int" value="170"/>
        <property name="misc-single-click" type="bool" value="false"/>
        <property name="misc-text-beside-icons" type="bool" value="false"/>
        <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_CUSTOM"/>
        <property name="shortcuts-icon-emblems" type="bool" value="true"/>
        <property name="tree-icon-emblems" type="bool" value="true"/>
        <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_50_PERCENT"/>
        <property name="last-details-view-column-widths" type="string" value="50,175,178,172,175,747,50,76,1686,285,50,72,50,145"/>
        <property name="last-sort-column" type="string" value="THUNAR_COLUMN_NAME"/>
        <property name="last-sort-order" type="string" value="GTK_SORT_ASCENDING"/>
        <property name="misc-middle-click-in-tab" type="bool" value="true"/>
        <property name="misc-date-custom-style" type="string" value="%a %-d %b %Y at %-H:%M"/>
        <property name="last-side-pane" type="string" value="ThunarShortcutsPane"/>
        <property name="last-details-view-visible-columns" type="string" value="THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE"/>
        <property name="last-splitview-separator-position" type="int" value="1040"/>
        <property name="last-show-hidden" type="bool" value="false"/>
      </channel>
    '';

    file.".config/Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
    	<icon>utilities-terminal</icon>
    	<name>Open Terminal Here</name>
    	<submenu></submenu>
    	<unique-id>1708650797419281-1</unique-id>
    	<command>alacritty --working-directory %f</command>
    	<description>Example for a custom action</description>
    	<range></range>
    	<patterns>*</patterns>
    	<startup-notify/>
    	<directories/>
    </action>
    </actions>
    '';
  };
}
