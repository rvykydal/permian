#!/bin/bash

CMD=$1

case $CMD in
#    full)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    full-dry-by-settings)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test --override kickstart_test.runner_command="echo <LAUNCHER>"  --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    dry-localrepo)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log --override kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test -o library.directPath=./tests/test_library/kickstart-test -o workflows.dry_run=True --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    dry)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test -o workflows.dry_run=True --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    mock-daily-iso)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./libpermian/plugins/kickstart_test/test_data/output_sample_1 --override kickstart_test.runner_command="./containers/runner/launch-mock.py 230 0" --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override kickstart_test.kstest_repo_branch="permian-mock-launcher" --testplan "daily daily-iso" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    mock-daily-iso-local)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./libpermian/plugins/kickstart_test/test_data/output_sample_1 --override kickstart_test.retry_on_failure=True --override kickstart_test.runner_command="/home/rvykydal/work/rtt-pipeline/poc/permian/tests/test_library/kickstart-test/results_parsing/launch-mock.py /home/rvykydal/work/rtt-pipeline/poc/permian/libpermian/plugins/kickstart_test/test_data/output_sample_1/kstest.413.daily-iso.log.txt 1000 0" --testplan "daily daily-iso" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    mock-daily-iso-dry)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./libpermian/plugins/kickstart_test/test_data/output_sample_1 -o workflows.dry_run=True --override kickstart_test.runner_command="./containers/runner/launch-mock.py 230 0" --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override kickstart_test.kstest_repo_branch="permian-mock-launcher" --testplan "daily daily-iso" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    dry-daily-iso-mock-obsolete)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=../../data/testlib/generated -o workflows.dry_run=True --testplan "daily daily-iso" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {"kickstart_tests_ref": "permian-mock-launcher", "kickstart_tests_repo": "https://github.com/rvykydal/kickstart-tests.git"} }'
#      ;;
#    daily-iso-dry-with-testplan)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./run_subset --debug-log permian.log -o library.directPath=../../data/testlib/generated -o workflows.dry_run=True --testplan "daily daily-iso" run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "daily-iso"} }'
#      ;;
#    daily-iso-dry)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "daily-iso"} }'
#      ;;
#    # THIS
#    rhel8-dry-scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test --override kickstart_test.retry_on_failure=True -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "rhel8", "platform": "rhel8"} }'
#      ;;
#    daily-iso-dry-scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test --override kickstart_test.retry_on_failure=True -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "daily-iso", "platform": ""} }'
#      ;;
#    # THIS
#    small-dry-scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test --override kickstart_test.retry_on_failure=True -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "small", "platform": "rhel9", "installation_tree": "http://download.eng.bos.redhat.com/rhel-9/development/RHEL-9/latest-RHEL-9.0/compose"} }'
#      ;;
#    small-dry-scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test --override kickstart_test.retry_on_failure=True -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "scenario": {"scenario": "small", "platform": "rhel9", "installation_tree": "http://download.eng.bos.redhat.com/rhel-9/development/RHEL-9/latest-RHEL-9.0/compose"} }'
#      ;;
#    small-dry-scenario-it)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o kickstart_test.kstest_local_repo=/var/tmp/kstests/kickstart-test --override kickstart_test.retry_on_failure=True -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "scenario": {"scenario": "small", "platform": "rhel9", "installation_tree": "http://download.eng.bos.redhat.com/rhel-9/development/RHEL-9/latest-RHEL-9.0/compose"} }'
#      ;;
#    rhel8-dry)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib ./pipeline --debug-log permian.log -o library.directPath=../../data/testlib/generated -o workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "rhel8"} }'
#      ;;
#    dry-testlib)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=/home/rvykydal/work/git/rvykydal/kickstart-tests/testlib -o workflows.dry_run=True --testplan "small" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
#      ;;
#    dry-repodir)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test -o workflows.dry_run=True --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {"ksrepo_dir": "/var/tmp/kstests/kickstart-tests"}}'
#      ;;
#    repodir)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {"ksrepo_dir": "/var/tmp/kstests/kickstart-tests"}}'
#      ;;
#    other-empty)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test -o workflows.dry_run=True --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {}}'
#      ;;
#    dry-scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test -o workflows.dry_run=True --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {"scenario": "rtt-pipeline-test", "kickstart_tests_ref": "rtt-pipeline", "kickstart_tests_repo": "https://github.com/rvykydal/kickstart-tests.git"} }'
#      ;;
#    scenario)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/rtt-pipeline/source/tclib PIPELINE_WebUI_listen_port=55577 ./run_subset --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test --testplan "kstests poc plan" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "other": {"scenario": "rtt-pipeline-test", "kickstart_tests_ref": "rtt-pipeline", "kickstart_tests_repo": "https://github.com/rvykydal/kickstart-tests.git"} }'
#      ;;
    mock-daily-iso-local)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log -o library.directPath=./tests/test_library/kickstart-test/results_parsing --override kickstart_test.retry_on_failure=True --override kickstart_test.runner_command="/home/rvykydal/work/git/rvykydal/permian/tests/test_library/kickstart-test/results_parsing/launch-mock.py /home/rvykydal/work/git/rvykydal/permian/tests/test_library/kickstart-test/results_parsing/kstest.daily-iso.stripped.log.txt 1000 0" run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}}'
      ;;
#    rhel8-dry-r1)
#      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "scenario": {"scenario": "rhel9", "platform": "rhel9", "testplan": "rhel9", "installation_tree": "http://download.eng.bos.redhat.com/rhel-9/development/RHEL-9/latest-RHEL-9.0/compose"} }'
#      ;;
    rhel8-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest.rhel8", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"} }'
      ;;
    platform-dry-review2)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-multiplatform", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"} }'
      ;;
    urls-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "installationUrls": {"x86_64": {"installation_tree": "TREE"}} }'
      ;;
    urls-dry-ob)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-poc", "installationUrls": {"x86_64": {"installation_tree": "http://download.eng.bos.redhat.com/rhel-9/development/RHEL-9/latest-RHEL-9.0/compose/BaseOS/x86_64/os"}} }'
      ;;
    arch-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-unsupported-arch", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"} }'
      ;;
    platform-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"} }'
      ;;
    urls-dry-2)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/basic --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "kstest-poc", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "", "urls":{"x86_64": {"installation_tree": "TREE"}}} }'
      ;;
    query-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./run_subset --testcase-query '"network" in tc.tags and "knownfailure" not in tc.tags' --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest.rhel8", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"} }'
      ;;
    query-dry-ever)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./run_subset --testcase-query '"network" in tc.tags and "knownfailure" not in tc.tags' --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "everything", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"}, "everything_testplan": {"configurations":[{"architecture": "x86_64"}], "point_person": "rvykydal@redhat.com", "reporting": [{"type": "xunit"}]} }'
      ;;
    query-dry-tp)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./run_subset --testcase-query '"network" in tc.tags and "knownfailure" not in tc.tags' --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.pr", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"} }'
      ;;
    query-dry-tp2)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./run_subset --testcase-query 'tc.name == "team"' --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.pr", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "rhel8"} }'
      ;;
    minimal-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest.minimal", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "fedora_rawhide"} }'
      ;;
    minimal)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/scenarios --override kickstart_test.retry_on_failure=True --override workflows.dry_run=False run_event '{"type": "github.scheduled.daily.kstest.minimal", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "fedora_rawhide"} }'
      ;;
    webui)
      TEST_JOBS=4 PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/webui --override kickstart_test.retry_on_failure=True --override workflows.dry_run=False run_event '{"type": "github.scheduled.daily.kstest.minimal", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "fedora_rawhide"} }'
      ;;
    webui-dry)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --override kickstart_test.kstest_repo="https://github.com/rvykydal/kickstart-tests.git" --override library.directPath=./tests/test_library/kickstart-test/webui --override kickstart_test.retry_on_failure=True --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest.minimal", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "fedora_rawhide"} }'
      ;;
    webui-dry-s)
      PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./pipeline --debug-log permian.log --settings test_settings.ini --override workflows.dry_run=True run_event '{"type": "github.scheduled.daily.kstest.minimal", "bootIso": {"x86_64":"file:///var/tmp/kstests/rawhide/boot.iso"}, "kstestParams": {"platform": "fedora_rawhide"} }'
      ;;
    unit)
        #./in_container ./unit_tests_local.py
        PYTHONPATH=${PYTHONPATH:-}:/home/rvykydal/work/git/rvykydal/tclib ./unit_tests_local.py
        ;;
    unit-all)
        ./in_container make test.unit
        ;;
    lint)
        ./in_container make test.lint
        ;;
    *)
        echo "Unknown command $CMD"
        ;;
esac
