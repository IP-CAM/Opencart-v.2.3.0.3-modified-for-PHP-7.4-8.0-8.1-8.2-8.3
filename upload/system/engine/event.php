<?php
namespace Opencart\System\Engine;

/*
* Event System Userguide
*
* https://github.com/opencart/opencart/wiki/Events-(script-notifications)-2.2.x.x
*/
class Event {
	protected $registry;
	protected $data = [];

	public function __construct($registry) {
		$this->registry = $registry;
	}

	public function register($trigger, \Action $action): void {
		$this->data[$trigger][] = $action;
	}

	public function trigger($event, array $args = []) {
		foreach ($this->data as $trigger => $actions) {
			if (preg_match('/^' . str_replace(['\*', '\?'], ['.*', '.'], preg_quote($trigger, '/')) . '/', $event)) {
				foreach ($actions as $action) {
					$result = $action->execute($this->registry, $args);

					if (null !== $result && !($result instanceof \Exception)) {
						return $result;
					}
				}
			}
		}
	}

	public function unregister($trigger, $route = ''): void {
		if ($route) {
			foreach ($this->data[$trigger] as $key => $action) {
				if ($action->getId() == $route) {
					unset($this->data[$trigger][$key]);
				}
			}
		} else {
			unset($this->data[$trigger]);
		}
	}

	public function removeAction($trigger, $route): void {
		foreach ($this->data[$trigger] as $key => $action) {
			if ($action->getId() == $route) {
				unset($this->data[$trigger][$key]);
			}
		}
	}
}
