import React, { useCallback } from 'react';
import { GitBranch } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { TooltipAnchor, Button } from '@librechat/client';

interface WorkflowButtonProps {
  isSmallScreen?: boolean;
  toggleNav: () => void;
}

export default function WorkflowButton({ isSmallScreen, toggleNav }: WorkflowButtonProps) {
  const navigate = useNavigate();

  const handleWorkflows = useCallback(() => {
    navigate('/workflows');
    if (isSmallScreen) {
      toggleNav();
    }
  }, [navigate, isSmallScreen, toggleNav]);

  return (
    <TooltipAnchor
      description={"Workflows"}
      render={
        <Button
          variant="outline"
          data-testid="nav-workflows-button"
          aria-label="Workflows"
          className="rounded-full border-none bg-transparent p-2 hover:bg-surface-hover md:rounded-xl"
          onClick={handleWorkflows}
        >
          <GitBranch className="icon-lg text-text-primary" />
        </Button>
      }
    />
  );
}
