################################################################################
#This is an internally genertaed by SpyGlass for Message Tagging Support
################################################################################


use spyglass;
use SpyGlass;
use SpyGlass::Objects;
spyRebootMsgTagSupport();

spySetMsgTagCount(140,45);
spyCacheTagValuesFromBatch(["RESET_INFO_01_SS_SCH"]);
spyCacheTagValuesFromBatch(["SETUP_LIBRARY_SS_RTL"]);
spyCacheTagValuesFromBatch(["SETUP_LIBRARY_SS_SCH"]);
spyParseTextMessageTagFile("./spyglass-1/soctop/cdc/cdc_setup_check/spyglass_spysch/sg_msgtag.txt");

if(!defined $::spyInIspy || !$::spyInIspy)
{
    spyDefineReportGroupingOrder("ALL",
(
"BUILTIN"   => [SGTAGTRUE, SGTAGFALSE]
,"TEMPLATE" => "A"
)
);
}
spyMessageTagTestBenchmark(117,"./spyglass-1/soctop/cdc/cdc_setup_check/spyglass.vdb");

1;
