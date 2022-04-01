################################################################################
#This is an internally genertaed by SpyGlass for Message Tagging Support
################################################################################


use spyglass;
use SpyGlass;
use SpyGlass::Objects;
spyRebootMsgTagSupport();

spySetMsgTagCount(19,40);
spyCacheTagValuesFromBatch(["AV_FSM_SS_SCH"]);
spyParseTextMessageTagFile("./spyglass-1/soctop/adv_lint/adv_lint_verify/spyglass_spysch/sg_msgtag.txt");

if(!defined $::spyInIspy || !$::spyInIspy)
{
    spyDefineReportGroupingOrder("ALL",
(
"BUILTIN"   => [SGTAGTRUE, SGTAGFALSE]
,"TEMPLATE" => "A"
)
);
}
spyMessageTagTestBenchmark(1,"./spyglass-1/soctop/adv_lint/adv_lint_verify/spyglass.vdb");

1;
