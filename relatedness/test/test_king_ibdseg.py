import time
import unittest
import sevenbridges as sbg
import logging
import datetime
from sevenbridges.http.error_handlers import (
    rate_limit_sleeper,
    maintenance_sleeper
)
TASK_TERMINAL_STATES = (
    sbg.TaskStatus.COMPLETED,
    sbg.TaskStatus.ABORTED,
    sbg.TaskStatus.FAILED
)
    
def reload(*tasks):
    """
    Reload task
    Args:
        *tasks:
    Returns:
    """
    for task in tasks:
        task.reload()
    if len(tasks) == 1:
        return tasks[0]
    return tasks

def wait(*tasks):
    """
    Wait until task is done
    Args:
        *tasks:
    Returns:
    """
    while not all(task.status in TASK_TERMINAL_STATES for task in tasks):
        time.sleep(30)
        reload(*tasks)
    return reload(*tasks)

class Platform(unittest.TestCase):
    """
    Execute platform test
    """
    # enables concurrent execution when run with nosetests
    _multiprocess_shared_ = True
    # for nosetests filtering
    project = None
    execution = "platform"
    profile_name = 'bdc'
    log_filename = 'UnitTest_KING_IBDseg'
    
    @classmethod
    def setUpClass(cls):
        """
        Get input files from the test project and start test task
        Returns:
        """
        # Log file prefix formatting
        prefix_date = str(datetime.datetime.now()).replace(
            ' ', '_'
        ).replace(
            '-', '_'
        )
        logging.basicConfig(
            filename=f'{prefix_date}_{cls.log_filename}.log',
            filemode='a',
            format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
            datefmt='%H:%M:%S',
            level=logging.INFO
        )
        cls.APP = 'smgogarten/genesis-relatedness/king-pipeline'
        cls.inputs = {}
        cls.TASK_NAME = 'UnitTest_KING_IBDseg'
        cls.metadata_status = 'fail'
        cls.naming_status = 'fail'
        if not cls.project:
            c = sbg.Config(profile=cls.profile_name)
            print(c)
            cls.session = sbg.Api(
                config=c,
                error_handlers=[
                    rate_limit_sleeper,
                    maintenance_sleeper
                ]
            )
            cls.project_name = 'smgogarten/genesis-relatedness'
            # SET INPUTS'
        cls.project = cls.session.projects.get(id=cls.project_name)
        cls.inputs['gds_file'] = cls.session.files.query(
            names=['ALL.pruned.gds'],
            project=cls.project
        )[0]
        cls.inputs['sample_include_file'] = cls.session.files.query(
            names=['sample_include.RData'],
            project=cls.project
        )[0]
        cls.inputs['phenotype_file'] = cls.session.files.query(
            names=['1KG_phase3_subset_annot.RData'],
            project=cls.project
        )[0]
        cls.inputs['out_prefix'] = 'unittest'
        cls.inputs['kinship_plot_threshold'] = 0.044
        cls.inputs['group'] = "Population"
        cls.inputs['sparse_threshold'] = 0.022
        cls.log = logging.getLogger("#unit_test")
        cls.log.info(f" Starting {cls.APP} test")
        # RUN TASKS
        try:
            cls.task = cls.session.tasks.create(
                name=cls.TASK_NAME,
                project=cls.project,
                app=cls.APP,
                inputs=cls.inputs,
                run=True
            )
            cls.log.info(f" Running {cls.APP} task")
            cls.log.info(f"#task_id {cls.task.id}")
        except:
            cls.log.info(f" I was unable to run {cls.APP} task")
            
    def tearDown(self):
        pass
    
    def test_run_status(self):
        """
        Test workflow execution on the platform
        Returns:
        """
        print(self.project)
        wait(self.task)
        self.log.info(f" Checking {self.APP} status")
        self.log.info(f" Task status {self.task.status}")
        self.assertEqual(self.task.status, 'COMPLETED')
        
    def test_outputs(self):
        """
        Test workflow output file naming
        """
        wait(self.task)
        if self.task.status == 'COMPLETED':
            self.log.info(f" Checking {self.APP} output naming")
            out_expected_name = 'unittest.seg'
            out_name = self.task.outputs['king_ibdseg_output'].name
            if out_name.startswith('_'):
                self.assertEqual(out_expected_name, '_'.join(out_name.split('_')[2:]))
            else:
                self.assertEqual(out_expected_name, out_name)
            out_expected_name = 'unittest_king_ibdseg_matrix.RData'
            out_name = self.task.outputs['king_ibdseg_matrix'].name
            if out_name.startswith('_'):
                self.assertEqual(out_expected_name, '_'.join(out_name.split('_')[2:]))
            else:
                self.assertEqual(out_expected_name, out_name)
            out_expected_name = 'unittest_king_ibdseg_all.pdf'
            out_name = self.task.outputs['king_ibdseg_plots'][0].name
            if out_name.startswith('_'):
                self.assertEqual(out_expected_name, '_'.join(out_name.split('_')[2:]))
            else:
                self.assertEqual(out_expected_name, out_name)
            self.assertTrue(len(self.task.outputs['king_ibdseg_plots']) > 1)
            self.output_status = 'passed'
            self.log.info(f"#output_test {self.output_status}")
            
if __name__ == "__main__":
    unittest.main(testRunner=unittest.TextTestRunner())
