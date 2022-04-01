################################################################################
#This is an internally genertaed by SpyGlass for Message Tagging Support
################################################################################


use spyglass;
use SpyGlass;
use SpyGlass::Objects;
spyRebootMsgTagSupport();

spySetMsgTagCount(140,45);
spyCacheTagValuesFromBatch(["CLOCK_SYNC05A_SS_SCH"]);
spyCacheTagValuesFromBatch(["CLOCK_SYNC05_SS_SCH"]);
spyCacheTagValuesFromBatch(["CLOCK_SYNC06A_SS_SCH"]);
spyCacheTagValuesFromBatch(["CLOCK_SYNC06_SS_SCH"]);
spyCacheTagValuesFromBatch(["QS_CSV_TAG"]);
spyCacheTagValuesFromBatch(["RESET_INFO_01_SS_SCH"]);
spyCacheTagValuesFromBatch(["SETUP_LIBRARY_SS_RTL"]);
spyCacheTagValuesFromBatch(["SETUP_LIBRARY_SS_SCH"]);
spyParseTextMessageTagFile("./spyglass-1/soctop/cdc/cdc_verify/spyglass_spysch/sg_msgtag.txt");

if(!defined $::spyInIspy || !$::spyInIspy)
{
    spyDefineReportGroupingOrder("ALL",
(
"BUILTIN"   => [SGTAGTRUE, SGTAGFALSE]
,"TEMPLATE" => "A"
)
);
}
spyMessageTagTestBenchmark(118,"./spyglass-1/soctop/cdc/cdc_verify/spyglass.vdb");

1;
